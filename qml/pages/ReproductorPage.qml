import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia
import QtCore
import IVIVI
Page {
    id: pageReproductor
    // Esta propiedad recibirá el valor desde Main.qml
    property string videoSource: ""

    background: Rectangle { color: Tema.fondo
    }

    MediaPlayer {
        id: player
        // Usamos la propiedad que nos enviaron
        source: pageReproductor.videoSource
        audioOutput: AudioOutput { volume: 1.0 }
        videoOutput: outputVideo

        // Importante: AutoPlay para que arranque directo
        autoPlay: true

        onErrorOccurred: (error, errorString) => {
            console.log("Error:", errorString)
        }
    }

    VideoOutput {
        id: outputVideo
        anchors.fill: parent
        // ... (Tu código del MouseArea para pausa/play está bien) ...
    }


    Button {
        id: btnVolver

        text: "X"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30
        z: 999

        height: 50
        width: 50

        contentItem: Text {
            text: btnVolver.text
            font.pixelSize: 30
            color: Tema.apartados // O el color que prefieras para la X
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle{
            anchors.fill: parent
            border.width: 2
            color: Tema.botones
            border.color: btnVolver.hovered ? Tema.principalI : Tema.fondo
            radius: 30
        }

        onClicked: {
            player.stop()
            if (pageReproductor.StackView.view) {
                pageReproductor.StackView.view.pop()
            }
        }

        hoverEnabled: true
    }
}
