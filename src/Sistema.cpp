//
// Created by rubfv on 23/11/25.
//

#include "Sistema.h"
#include "Video.h"
#include <QStandardPaths>
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QDateTime>
#include <QTextStream>

Sistema::Sistema(QObject *parent) : QObject(parent) {
    inicializarDirDatos();
    cargarBaseDeDatos();
}

void Sistema::inicializarDirDatos() {
    QString rutaBase = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);

    if (rutaBase.isEmpty()) {
        rutaBase = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    }

    const QDir dir(rutaBase);
    if (!dir.exists()) {
        if (dir.mkpath(".")) {
            qDebug() << "Carpeta del sistema creada en: " << dir.absolutePath();
        } else {
            qDebug() << "Error critico, no se pudo crear la carpeta de Datos!";
        }
    }

    dirDatos = dir;
    qDebug() << "Base de datos creada en: " << dirDatos.absoluteFilePath("usuarios.dat");
}

bool Sistema::registrarUsuario(const QString &nombre, const QString &password) {
    for (const auto &usu : usuariosList) {
        if (usu.getNombre() == nombre) {
            qDebug() << "Usuario ya existente";
            return false;
        }
    }
    const Usuario usuarioNuevo(nombre, password);
    usuariosList.append(usuarioNuevo);

    guardarBaseDeDatos();

    qDebug() << "Usuario registrado" << usuarioNuevo.getNombre();
    return true;
}

bool Sistema::iniciarSesion(const QString & nombre, const QString & password) {
    for (auto & i : usuariosList) {
        if (i.getNombre() == nombre && i.validarPassword(password)) {
            usuarioActual = &i;

            qDebug() << "Sesion iniciada";
            registrarEnBitacora("Inicio de sesión correcta");
            emit usuarioCambiado();
            return true;
        }
    }
    qDebug() << "Credenciales incorrectas";
    registrarEnBitacora("Inicio de sesión incorrecta, Nombre:" + nombre + "Contraseña: " + password);
    return false;
}

void Sistema::cerrarSesion() {
    registrarEnBitacora("Sesion cerrada");
    usuarioActual = nullptr;
    qDebug() << "Sesion cerrada";
    emit usuarioCambiado();
}

QString Sistema::getNombreUsuarioActual() const{
    if (usuarioActual) return usuarioActual->getNombre();
    return "";
}

bool Sistema::importarVideo(const QUrl &url) const {
    if (!usuarioActual) {
        qDebug() << "No hay sesion activa";
        return false;
    }
    const QString rutaAbsoluta = url.toLocalFile();
    const QFileInfo info(rutaAbsoluta);

    if (!info.exists() || !info.isFile()) {
        qDebug() << "Archivo invalido: " << rutaAbsoluta;
        return false;
    }

    const Video nuevoVideo(info.baseName(), rutaAbsoluta, info.suffix(), info.size());

    usuarioActual->agregarVideo(nuevoVideo);

    guardarBaseDeDatos();

    registrarEnBitacora("Se importe video: " + nuevoVideo.getTitulo());
    qDebug() << "Video importado a la biblioteca de: " << usuarioActual->getNombre();
    return true;
}

QVariantList Sistema::getVideosUsuario() const {
    QVariantList listaParaQML;

    if (!usuarioActual) return listaParaQML;

    const auto &biblioteca = usuarioActual->getVideos();

    for (const auto &video : biblioteca) {
        QVariantMap mapaVideo;
        mapaVideo["titulo"] = video.getTitulo();
        mapaVideo["ruta"] = video.getRuta();
        mapaVideo["formato"] = video.getFormato();

        const double mb = video.getTamanoBytes() / (1024.0 * 1024.0);
        mapaVideo["peso"] = QString::number(mb, 'f', 1)+ "MiB" ;

        listaParaQML.append(mapaVideo);
    }
    return listaParaQML;
}


QUrl Sistema::obtenerUrlCompleta(const QString &rutaAbsoluta) {
    return QUrl::fromLocalFile(rutaAbsoluta);
}

QString Sistema::obtenerRutaDirDatos() const {
    return dirDatos.absolutePath();
}

void Sistema::guardarBaseDeDatos() const {


    QFile file(dirDatos.filePath("usuarios.dat"));

    if (file.open(QIODevice::WriteOnly)) {
        QDataStream out(&file);

        out << usuariosList;

        file.close();
        qDebug() << "Base de datos guardada. Tamaño del archivo:" << file.size() << "bytes.";
    } else {
        qDebug() << "ERROR AL GUARDAR:" << file.errorString();
    }
}



void Sistema::cargarBaseDeDatos() {
    QFile file(dirDatos.filePath("usuarios.dat"));

    if (!file.exists()) {
        qDebug() << "No existe base de datos previa. Iniciando sistema limpio";
        return;
    }

    if (file.open(QIODevice::ReadOnly)) {
        QDataStream in(&file);

        usuariosList.clear();
        in >> usuariosList;

        file.close();
        qDebug() << "Base de datos cargada. Usuarios registrados: " << usuariosList.size();
    } else {
        qDebug() << "Error al leer base de datos";
    }
}

bool Sistema::generarReporteVideos() const {
    if (!usuarioActual) return false;

    const QString ruta = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QFile archivo(ruta + "/Reporte_IVIVI_" + usuarioActual->getNombre() + ".txt");

    if (archivo.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&archivo);

        out << "~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~\n";
        out << "|        Reporte de videos - IVIVI          |\n ";
        out << "~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~\n";
        out << "Usario: " << usuarioActual->getNombre() << "\n";
        out << "Fecha: " << QDateTime::currentDateTime().toString() << "\n";
        out << "<> <> <> <> <> <> <> <> <> <> <> <> <> <> <>\n";


        const QList<Video> &lista = usuarioActual->getVideos();
        qint64 pesoTotal = 0;

        out << "Videos Registrados: \n";
        for (const Video &video : lista) {
            out << " -> [ " << video.getFormato().toUpper() << " ] " << video.getTitulo();
            out << " (" << QString::number(video.getTamanoBytes() / 1024 / 1024) << " MB)\n";
            out << " Ruta: " << video.getRuta() << "\n\n\n";
            pesoTotal += video.getTamanoBytes();
        }
        out << "<> <> <> <> <> <> <> <> <> <> <> <> <> <> <>\n";
        out << "Total de videos: " << lista.size() << "\n";
        out << "Espacio total usado:" << QString::number(pesoTotal / 1024 / 1024) << "MiB\n";

        archivo.close();
        qDebug() << "ReporteGenerado en:" << archivo.fileName();
        registrarEnBitacora("El usuario genero un reporte de videos");
        return true;
    }
    return false;
}

void Sistema::registrarEnBitacora(const QString &accion) const {
    QFile archivo(dirDatos.filePath("bitacora_sistema.txt"));

    if (archivo.open(QIODevice::Append | QIODevice::Text)) {
        QTextStream out(&archivo);

        const QString usuario = (usuarioActual) ? usuarioActual->getNombre() : "SISTEMA";
        const QString tiempo = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");

        out << "[" << tiempo << "] [" << usuario << "]: " << accion << "\n";
        archivo.close();
    }
}



