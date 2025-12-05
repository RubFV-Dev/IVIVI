import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import IVIVI

Page {
    id: loginPage
    background: Rectangle { color: Tema.fondo }

    ColumnLayout{
        anchors.centerIn: parent
        width: 300
        spacing: 20

        Text {
            text: "IVIVI LOGIN"
            color: Tema.principalI
            font.pixelSize: 40
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        TextField{
            id: userInput
            placeholderText: "Usuario"
            Layout.fillWidth: true
            font.pixelSize: 16
            background : Rectangle {
                color: Tema.apartados
                radius: 5
            }
        }

        TextField {
            id: passInput
            placeholderText: "Contraseña"
            echoMode: TextInput.Password // Oculta el texto
            Layout.fillWidth: true
            font.pixelSize: 16
            background: Rectangle {
                color: "white"
                radius: 5
            }
        }

        Button {
            text: "Iniciar Sesión"
            Layout.fillWidth: true
            background: Rectangle {
                color: parent.down ? Tema.principalII : Tema.principalI
                radius: 5
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }
            onClicked: {
                // Llamamos a C++
                var exito = gestorGlobal.iniciarSesion(userInput.text, passInput.text)
                if (exito) {
                    // Si entra, el Main.qml detectará el cambio y mostrará el menú
                    stackView.replace("HomePage.qml")
                } else {
                    errorMsg.text = "Usuario o contraseña incorrectos"
                }
            }
        }

        Button {
            text: "Registrarse"
            Layout.fillWidth: true
            background: Rectangle {
                color: "transparent"
                border.color: Tema.principalI
                border.width: 1
                radius: 5
            }
            contentItem: Text {
                text: parent.text
                color: Tema.principalI
                horizontalAlignment: Text.AlignHCenter
            }
            onClicked: {
                // Llamamos a C++ para crear usuario y guardarlo en el BINARIO
                var creado = gestorGlobal.registrarUsuario(userInput.text, passInput.text)
                if (creado) {
                    errorMsg.text = "Usuario creado. Ya puedes iniciar sesión."
                    errorMsg.color = "green"
                } else {
                    errorMsg.text = "El usuario ya existe."
                    errorMsg.color = "red"
                }
            }
        }

        Text {
            id: errorMsg
            text: ""
            color: "red"
            Layout.alignment: Qt.AlignHCenter
        }
    }
}