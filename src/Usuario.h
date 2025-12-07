//
// Created by rubfv on 04/12/25.
//

#ifndef IVIVI_USUARIOS_H
#define IVIVI_USUARIOS_H

#include <QList>
#include "Video.h"

class Usuario {
    QString nombreUsuario;
    QString passwordUsuario;
    QList<Video> videosUsuario;
public:
    //<| Constructores |>
    Usuario() = default;
    Usuario(const QString &, const QString &);

    //<| Agregar videos a las lista |>
    void agregarVideo(const Video&);

    bool eliminarVideo(const QString&);

    // <| Validar contraseña
    [[nodiscard]] bool validarPassword(const QString& ) const;

    //<| Getters |>
    [[nodiscard]] QString getNombre() const;
    [[nodiscard]] QList<Video> getVideos() const;

    // <| Sobrecargas para binarios |>
    friend QDataStream &operator<<(QDataStream&, const Usuario&);
    friend QDataStream &operator>>(QDataStream&, Usuario&);
};


#endif //IVIVI_USUARIOS_H