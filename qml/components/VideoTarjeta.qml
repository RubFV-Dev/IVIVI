import QtQuick
import IVIVI

Item {
    id: root
    width: 160
    height: 240

    property string titulo: "Desconocido"

    signal clickeado()


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

    MouseArea {
        id: areaMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clickeado()
    }
}