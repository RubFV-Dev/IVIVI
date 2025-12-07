//
// Created by rubfv on 23/11/25.
//

#ifndef IVIVI_SISTEMA_H
#define IVIVI_SISTEMA_H

#include <QDir>
#include <QObject>
#include <QUrl>
#include <QtQml/qqmlregistration.h>

#include "Usuario.h"

class Sistema : public QObject{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString nombreUsuarioActual READ getNombreUsuarioActual NOTIFY usuarioCambiado)
public:
    explicit  Sistema(QObject *parent = nullptr);

    Q_INVOKABLE bool registrarUsuario(const QString &, const QString &);
    Q_INVOKABLE bool iniciarSesion(const QString &, const QString &);
    Q_INVOKABLE void cerrarSesion();

    [[nodiscard]] QString getNombreUsuarioActual() const;

    Q_INVOKABLE [[nodiscard]] bool importarVideo(const QUrl&);
    Q_INVOKABLE [[nodiscard]] bool eliminarVideo(const QString  & ruta);
    Q_INVOKABLE [[nodiscard]] QVariantList getVideosUsuario() const;
    Q_INVOKABLE static QUrl obtenerUrlCompleta(const QString&);
    Q_INVOKABLE [[nodiscard]] QString obtenerRutaDirDatos() const;

    // <| Archivos de texto |>
    Q_INVOKABLE [[nodiscard]] bool generarReporteVideos() const;
    void registrarEnBitacora(const QString&) const;

    signals:
    void usuarioCambiado();
private:
    QList<Usuario> usuariosList;

    int indexUsuarioActual = -1;

    Usuario* getUsuarioActual();
    [[nodiscard]] const Usuario* getUsuarioActual() const;

    QDir dirDatos;
    void inicializarDirDatos();

    void guardarBaseDeDatos() const;
    void cargarBaseDeDatos();
};


#endif //IVIVI_SISTEMA_H