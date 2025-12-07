import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore
import IVIVI

Page {
    id: paginaVideos
    background: Rectangle { color: Tema.fondo} // Fondo negro

    signal videoSeleccionado(string rutaVideo)

    ListModel {
        id: modeloVideos
    }

    function cargarVideos() {
        modeloVideos.clear() // Limpiamos por si acaso

        var lista = gestorGlobal.getVideosUsuario()

        for (var i = 0; i < lista.length; i++) {

            modeloVideos.append({
                "tituloVideo": lista[i].titulo,
                "rutaVideo": lista[i].ruta,
                "pesoVideo": lista[i].peso,
                "esBotonAgregar": false
            })
        }

        modeloVideos.append({
            "tituloVideo": "",
            "rutaVideo": "",
            "pesoVideo": "",
            "esBotonAgregar": true
        })
    }

    Component.onCompleted: cargarVideos()


    // --- 3. LA GRILLA (GridView) ---
    GridView {
        id: grid
        anchors.fill: parent
        anchors.margins: 25
        cellWidth: 180
        cellHeight: 260
        clip: true
        model: modeloVideos

        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight


            Loader{
                anchors.centerIn: parent

                width: parent.width - 10
                height: parent.height - 10

                sourceComponent: model.esBotonAgregar ? addBoton : videoTarjetas
            }

            Component{
                id: videoTarjetas
                VideoTarjeta {
                    titulo: model.tituloVideo

                    onClicked: {
                        console.log("Solicitando video ruta: " + model.rutaVideo)
                        paginaVideos.videoSeleccionado(model.rutaVideo)
                    }

                    onEliminarClicked: {
                        console.log("Eliminado: " + model.rutaVideo)
                        var borrado = gestorGlobal.eliminarVideo(model.rutaVideo)

                        if (borrado){
                            cargarVideos()
                        }
                    }
                }
            }

            // Boton de añadir video
            Component{
                id: addBoton
                Rectangle {
                    color: "transparent"
                    border.width: 2
                    radius: 10

                    property string colorInteractivo: mouseAreaBoton.containsMouse ? Tema.addBotonH : Tema.addBoton

                    border.color: colorInteractivo

                    Text {
                        anchors.centerIn: parent
                        text: "+"
                        font.pixelSize: 60
                        color: parent.colorInteractivo
                    }

                    Text {
                        id: addText
                        anchors.top: parent.verticalCenter
                        anchors.topMargin: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Añadir"
                        color: parent.colorInteractivo
                        font.pixelSize: 16
                    }

                    MouseArea {
                        id: mouseAreaBoton
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            fileDialog.open()
                        }
                    }
                }

            }

        }

        // Barra de desplazamiento (Scrollbar) estilo Netflix
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            active: grid.moving // Se ilumina al moverlo
        }
    }


    FileDialog{
        id : fileDialog
        title: "Elige el video a cargar"
        currentFolder: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]
        nameFilters : ["Video Files (*.mp4 *.avi *.mov *.webm)"]

        onAccepted: {
            gestorGlobal.importarVideo(selectedFile)
            cargarVideos()
        }
    }
}