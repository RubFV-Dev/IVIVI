import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia
import QtCore
import IVIVI

ApplicationWindow {
    id: mainWindow
    visible: true

    width: Screen.width * 0.9
    height: Screen.height * 0.9

    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    minimumWidth: 800
    minimumHeight: 600

    property bool modoCine: false

    GestorVideos {
        id: gestorGlobal
    }

    function cambiarPagina(rutaArchivo) {
        stackView.replace(rutaArchivo);
    }

    header: ToolBar {

        id: menuPrincipal

        visible: !modoCine

        height: visible ? 55 : 0

        background: Rectangle {
            color: Tema.apartados
        } // Color de tu Tema

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 50


            Label {
                text: "IVIVI"
                color: Tema.principalI
                font.bold: true
                font.pixelSize: 35
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            } // Espaciador flexible


            // 3. MENÚ DE ESCRITORIO (Solo visible en PC)
            Row {
                visible: true
                spacing: 35

                // Botones de navegación rápida
                BotonMenu {
                    text: "Inicio"; onClicked: cambiarPagina("pages/HomePage.qml")
                }
                BotonMenu {
                    text: "Videos"; onClicked: cambiarPagina("pages/VideosPage.qml")
                }
                BotonMenu {
                    text: "Perfil"; onClicked: cambiarPagina("pages/PerfilPage.qml")
                }
            }
        }

    }
    StackView {
        id: stackView
        anchors.fill: parent

        // Carga la página inicial.
        // IMPORTANTE: La ruta es relativa al módulo QML
        initialItem: "pages/HomePage.qml"

        // Animación de transición (opcional, queda muy pro)
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity";
                from: 0;
                to: 1; duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity";
                from: 1;
                to: 0; duration: 200
            }
        }
        replaceEnter: Transition {
            PropertyAnimation {
                property: "opacity";
                from: 0;
                to: 1; duration: 200
            }
        }
        replaceExit: Transition {
            PropertyAnimation {
                property: "opacity";
                from: 1;
                to: 0; duration: 200
            }
        }

        popEnter: Transition {
            PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        }
        popExit: Transition {
            PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
        }
        onDepthChanged: {
            if (depth === 1) {
                modoCine = false
            }
        }
    }

    Connections {
        target: stackView.currentItem

        // Ignorar señales desconocidas es útil porque HomePage no tiene esta señal, pero VideosPage sí
        ignoreUnknownSignals: true

        // Escuchamos la señal que creamos en PaginaVideos.qml
        function onVideoSeleccionado(rutaVideo) {
            console.log("Main recibió solicitud de video: " + rutaVideo)

            var urlCompleta = gestorGlobal.obtenerUrlCompleta(rutaVideo)

            modoCine = true

            stackView.push("pages/ReproductorPage.qml", {"videoSource" : urlCompleta})
        }

    }

    component BotonMenu : Button {
        background: Rectangle {
            color: "transparent"
        }
        contentItem: Text {
            text: parent.text
            color: parent.down ? Tema.principalII : "white"
            font.bold: true
            font.pixelSize: 20
        }
    }


}