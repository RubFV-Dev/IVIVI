import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia
import QtCore
import IVIVI

Page {

}
/*
Page {
    id: pageReproductor
    title: "Reproductor de Video"

    property string videoSource: ""

    // Señal para avisar al Main (por si acaso)
    signal cerrar()

    background: Rectangle {
        id: fondo
        color: "black"
    }

    function corregirRuta(ruta) {
        if (!ruta) return ""
        var s = ruta.toString()
        if (s.indexOf("http") === 0) return s
        if (s.indexOf("file://") === 0) return s
        return "file:///" + s
    }

    MediaPlayer {
        id: player
        source: corregirRuta(pageReproductor.videoSource)
        audioOutput: AudioOutput { volume: 1.0 }
        videoOutput: outputVideo
        autoPlay: true

        onErrorOccurred: (error, errorString) => {
            console.log("Error Multimedia:", errorString)
            txtEstado.text = "⚠️ Error: " + errorString
            txtEstado.color = "red"
        }
    }

    VideoOutput {
        id: outputVideo
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectFit
        z: 0

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (player.playbackState === MediaPlayer.PlayingState)
                    player.pause()
                else
                    player.play()
            }
        }
    }

    // --- INDICADOR DE ESTADO ---
    Rectangle {
        anchors.centerIn: parent
        width: 300
        height: 100
        radius: 10
        color: "#AA000000"
        visible: player.playbackState !== MediaPlayer.PlayingState
        z: 10

        Column {
            anchors.centerIn: parent
            spacing: 10
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: player.playbackState === MediaPlayer.PausedState ? "▶" : "..."
                color: "white"
                font.pixelSize: 40
            }
        }
    }

    // --- BOTÓN VOLVER (LÓGICA MEJORADA) ---
    Button {
        id: btnCerrar
        text: "← VOLVER"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30
        width: 120
        height: 50
        z: 999

        background: Rectangle {
            color: btnCerrar.down ? "red" : "#80000000"
            radius: 8
            border.color: "white"
            border.width: 1
        }
        contentItem: Text {
            text: parent.text
            color: "white"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: {
            console.log("Intentando salir...")
            player.stop()

            // 1. Intentamos la vía estándar
            if (pageReproductor.StackView.view) {
                pageReproductor.StackView.view.pop()
                return
            }

            // 2. BUSQUEDA MANUAL DEL STACKVIEW (La solución definitiva)
            // Subimos por los padres hasta encontrar alguien que tenga la función 'pop'
            var candidato = pageReproductor.parent
            var encontrado = false
            while (candidato) {
                if (candidato.pop && typeof candidato.pop === 'function') {
                    console.log("StackView encontrado manualmente, ejecutando pop()")
                    candidato.pop()
                    encontrado = true
                    break
                }
                candidato = candidato.parent
            }

            // 3. Sio falla, emitimos señal y nos ocultamos
            if (!encontrado) {
                console.log("No se encontró StackView, usando señal de emergencia")
                pageReproductor.cerrar() // Main.qml debería escuchar esto
                pageReproductor.visible = false
            }
        }
    }
}
*/
