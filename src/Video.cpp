//
// Created by rubfv on 04/12/25.
//


#include "Video.h"

Video::Video(const QString &titulo, const QString &ruta, const QString &formato, const qint64 tamano)
    :  tituloVideo(titulo) , rutaVideos(ruta), formatoVideo(formato), tamanoBytes(tamano){}

QString Video::getTitulo() const {return tituloVideo;}
QString Video::getRuta() const {return rutaVideos;}
QString Video::getFormato() const {return formatoVideo;}
qint64 Video::getTamanoBytes() const {return tamanoBytes;}

QDataStream &operator<<(QDataStream &out, const Video &v) {
    out << v.tituloVideo << v.tituloVideo << v.formatoVideo << v.tamanoBytes;
    return out;
}

QDataStream &operator>>(QDataStream &in, Video &v) {
    in >> v.tituloVideo >> v.rutaVideos >> v.formatoVideo >> v.tamanoBytes;
    return in;
}
