import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore
import IVIVI

Page {
    id: paginaVideos
    background: Rectangle { color: Tema.fondo} // Fondo negro

    signal videoSeleccionado(string rutaVideo)

    GestorVideos {
        id: gestorBackend
    }


    ListModel {
        id: modeloVideos
        // Al principio está vacío. Lo llenaremos con C++
    }

    function cargarVideos() {
        modeloVideos.clear() // Limpiamos por si acaso

        var lista = gestorBackend.obtenerVideos()

        for (var i = 0; i < lista.length; i++) {

            modeloVideos.append({
                "nombreArchivo": lista[i],
                "esBotoAgregar":false
            })
        }

        modeloVideos.append({
            "nombreArchivo": "",
            "esBotonAgregar": true   // Marcamos que este es el botón
        })
    }

    // Cargar automáticamente al abrir la página
    Component.onCompleted: cargarVideos()


    // --- 3. LA GRILLA (GridView) ---
    GridView {
        id: grid
        anchors.fill: parent
        anchors.margins: 25

        // Configuración de la celda (Tamaño tarjeta + espacio)
        cellWidth: 180
        cellHeight: 260

        clip: true // Para que el scroll no se salga del cuadro

        // Conectamos con el modelo
        model: modeloVideos

        // El delegado, es decir, qué cosas va a estar en la Grilla, que objeto o item
        // En este caso en un delegado inteligente, ya que recibe Item, dandole la capacidad de tener diferentes cosas
        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight

            // Marco de componentes
            Loader{
                anchors.centerIn: parent

                width: parent.width - 10
                height: parent.height - 10

                sourceComponent: model.esBotonAgregar ? addBoton : videoTarjetas
            }

            // Tarjeta de los videos
            Component{
                id: videoTarjetas
                VideoTarjeta {
                    titulo: model.nombreArchivo

                    onClickeado: {
                        console.log("Solicitando video: " + titulo)
                        paginaVideos.videoSeleccionado(titulo)
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
            gestorBackend.importarVideo(selectedFile)
            cargarVideos()
        }
    }
}