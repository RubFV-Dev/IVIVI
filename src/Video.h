//
// Created by rubfv on 04/12/25.
//

#ifndef IVIVI_VIDEO_H
#define IVIVI_VIDEO_H

#include <QString>
#include <QDataStream>

class Video {
    QString tituloVideo;
    QString rutaVideos;
    QString formatoVideo;
    qint64 tamanoBytes;
public:
    //<| Constructores |>
    Video() = default;
    Video(const QString &, const QString &, const QString &, qint64);

    // <| Getters |>
    QString getTitulo() const;
    QString getRuta() const;
    QString getFormato() const;
    qint64 getTamanoBytes() const;

    // <| Sobrecargas para binarios |>
    friend QDataStream &operator<<(QDataStream &, const Video&);
    friend QDataStream &operator>>(QDataStream &, Video&);

};


#endif //IVIVI_VIDEO_H