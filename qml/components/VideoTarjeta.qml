import QtQuick
import IVIVI

Item {
    id: root
    width: 160
    height: 240

    property string titulo: "Desconocido"

    signal clicked()
    signal eliminarClicked()


    Rectangle {
        id: fondo
        anchors.fill: parent
        radius: 10
        color: Tema.apartados
        border.width:2
        border.color: areaMouse.containsMouse ? Tema.principalI : "transparent"
    }
    Text {
        text: "▶"
        font.pixelSize: 50
        color: Tema.botones
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -20
    }

    // El Título del video
    Text {
        text: root.titulo
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        anchors.bottomMargin: 15

        color: Tema.texto
        font.bold: true
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        maximumLineCount: 2
        elide: Text.ElideRight
    }

    Rectangle {
        id: btnBasura
        width: 30
        height: 30
        radius: 15
        color: Tema.principalII

        // Lo colocamos en la esquina superior derecha
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5
        z: 10 // Para que quede encima de all

        Text {
            anchors.centerIn: parent
            text: "X" // O usa un icono si tienes fuente de iconos
            color: Tema.botones
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // Emitimos la señal para que VideosPage se encargue
                root.eliminarClicked()
            }
        }
    }

    MouseArea {
        id: areaMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}