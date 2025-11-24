//
// Created by rubfv on 23/11/25.
//

#include "GestorVideos.h"

#include <QStandardPaths>
#include <QDebug>
#include <QFile>
#include <QFileInfo>

GestorVideos::GestorVideos(QObject *parent) : QObject(parent) {
    inicializarDirTrabajo();
}

void GestorVideos::inicializarDirTrabajo() {
    QString rutaBase = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);

    if (rutaBase.isEmpty()) {
        rutaBase = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    }

    QDir dir(rutaBase);
    const QString nombreDir = "IVIVI_Media";

    if (!dir.exists(nombreDir)) {
        if (dir.mkpath(nombreDir)) {
            qDebug() << "Carpeta creada en: " << nombreDir;
        } else {
            qDebug() << "NO SE PUDO CREAR LA CARPETA EN: " << nombreDir;
            dir = QDir(QStandardPaths::writableLocation(QStandardPaths::TempLocation));
            if (dir.mkdir(nombreDir)) {
                qDebug() << "Carpeta temporal creada (Emergencia): " << dir.filePath(nombreDir);
            } else {
                qDebug() << "NO SE PUDO CREAR CARPETA TEMPORAL (EMERGENCIA TOTAL)";
                return;
            }
        }
    }

    if (dir.cd(nombreDir)){
        dirTrabajo = dir;
        qDebug() << "Directorio de trabajo activo: " << dirTrabajo.absolutePath();
    } else {
        qDebug() << "Error al entrar al directorio final";
    }
}

QStringList GestorVideos::obtenerVideos() {
    QStringList filtros;
    filtros << "*.mp4" << "*.avi" << "*.mov"<< "*.webm";

    dirTrabajo.setNameFilters(filtros);

    return dirTrabajo.entryList(QDir::Files, QDir::Name);
}

bool GestorVideos::importarVideo(const QUrl &url) const {
    const QString rutaLocal = url.toLocalFile();

    if (!QFile::exists(rutaLocal)) {
        qDebug() << "El archivo no exite: " << rutaLocal;
        return false;
    }

    const QFileInfo info(rutaLocal);
    const QString nombre = info.fileName();

    const QString rutaDestino = dirTrabajo.filePath(nombre);

    if (QFile::exists(rutaDestino)) {
        qDebug() << "El archivo existe: " << rutaDestino;
        return true;
    }

    if (QFile::copy(rutaLocal, rutaDestino)) {
        qDebug() << "El archivo se copio exitosamente: " << rutaLocal;
        return true;
    }
    qDebug() << "Error al copiar el archivo: " << rutaLocal;
    return false;
}

QUrl GestorVideos::obtenerUrlCompleta(const QString &ruta) const {
    return QUrl::fromLocalFile(dirTrabajo.absoluteFilePath(ruta));
}

QString GestorVideos::obtenerRutaDirTrabajo() const {
    return dirTrabajo.absolutePath();
}
