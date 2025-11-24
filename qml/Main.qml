import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtMultimedia
import QtCore
import IVIVI

ApplicationWindow {
    visible: true
    width: 400; height: 400

    GestorVideos{
        id : gestor
    }

    Column {
        anchors.centerIn: parent
        spacing:20

        Text {
            text : "Ruta de tus videos:"
            font.bold : true
        }
        Text {
            text : gestor.obtenerRutaDirTrabajo()
            color: "blue"
        }
        Button{
            text:"Escanear videos:"
            onClicked: {
                fileDialog.open()
            }
        }
        FileDialog{
            id : fileDialog
            title: "Elige el viedo a cargar"
            currentFolder: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]
            nameFilters : ["Video Files (*.mp4 *.avi *.mov *.webm)"]

            onAccepted: {
                gestor.importarVideo(selectedFile)
            }
        }
    }
}