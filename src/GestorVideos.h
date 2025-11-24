//
// Created by rubfv on 23/11/25.
//

#ifndef IVIVI_GESTORVIDEOS_H
#define IVIVI_GESTORVIDEOS_H

#include <QDir>
#include <QObject>
#include <QUrl>
#include <QtQml/qqmlregistration.h>

class GestorVideos : public QObject{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit  GestorVideos(QObject *parent = nullptr);
    Q_INVOKABLE QStringList obtenerVideos();
    Q_INVOKABLE [[nodiscard]] bool importarVideo(const QUrl&) const;
    Q_INVOKABLE [[nodiscard]] QUrl obtenerUrlCompleta(const QString&) const;
    Q_INVOKABLE [[nodiscard]] QString obtenerRutaDirTrabajo() const;
private:
    QDir dirTrabajo;
    void inicializarDirTrabajo();
};


#endif //IVIVI_GESTORVIDEOS_H