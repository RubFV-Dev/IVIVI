import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import IVIVI

Page{
    id : paginaHome
    background: Rectangle { color: Tema.fondo}

    ColumnLayout{
        anchors.centerIn :parent
        spacing:10

        Text {
            text: "Bienvenido/a a IVIVI"
            color: Tema.principalI
            font.pixelSize: 40
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: "Increible VIsualizador de VIdeos"
            color: Tema.principalII
            font.pixelSize: 30
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Tu gestor de videos personal"
            color: Tema.texto
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }

        Item { height: 30; width: 1 }

        Text {
            text: "Selecciona 'Videos' en el menú\npara comenzar a ver tu contenido."
            color: Tema.botones
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }
}