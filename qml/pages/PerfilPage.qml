import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import IVIVI

Page{
    id : paginaUsuarios
    background: Rectangle { color: Tema.fondo}

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30
        width: 300

        Rectangle{
            Layout.alignment: Qt.AlignHCenter
            width: 100
            height: 100
            radius: 50
            color: Tema.apartados
            border.color: Tema.principalI
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "👤"
                font.pixelSize: 55
                color: Tema.texto
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: gestorGlobal.nombreUsuarioActual
            color: Tema.texto
            font.bold: true
            font.pixelSize: 24
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Tema.botones
        }

        Button{
            text: "📄 Generar Reporte .txt"
            Layout.fillWidth: true
            background: Rectangle{
                color: parent.down ? Tema.principalII : Tema.apartados

                radius: 5
                border.color: Tema.principalI
                border.width: 1
            }
            contentItem: Text{
                text: parent.text
                color: Tema.texto
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }
            onClicked: {
                var resultado = gestorGlobal.generarReporteVideos()
                if (resultado) console.log("Reporte creado en Documentos")
            }
        }

        Button {
            text: "Cerrar Sesión"
            Layout.fillWidth: true
            background: Rectangle {
                color: "red"
                radius: 5
                opacity: parent.down ? 0.7 : 1.0
            }
            contentItem: Text {
                text: parent.text
                color: Tema.texto
                font.pixelSize: 20
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }
            onClicked: {
                gestorGlobal.cerrarSesion()
                stackView.replace("LoginPage.qml")
            }
        }
    }
}