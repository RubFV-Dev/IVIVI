//
// Created by rubfv on 04/12/25.
//

#include "Usuario.h"

Usuario::Usuario(const QString &nombre, const QString &password)
    : nombreUsuario(nombre), passwordUsuario(password){}

void Usuario::agregarVideo(const Video& video) {
    videosUsuario.append(video);
}

bool Usuario::validarPassword(const QString& password) const {return password == passwordUsuario;}

QString Usuario::getNombre() const {return nombreUsuario;}
QList<Video> Usuario::getVideos() const {return videosUsuario;}

QDataStream &operator<<(QDataStream &out, const Usuario &usuario) {
    out << usuario.nombreUsuario << usuario.passwordUsuario << usuario.videosUsuario;
    return out;
}

QDataStream &operator>>(QDataStream &in, Usuario &usuario) {
    in >> usuario.nombreUsuario >> usuario.passwordUsuario >> usuario.videosUsuario;
    return in;
}