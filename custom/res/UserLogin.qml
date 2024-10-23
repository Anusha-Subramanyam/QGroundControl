import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Controls 1.3
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs  1.2
import QtQuick.Layouts      1.2
import QtGraphicalEffects 1.15

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0
Item {
    property alias userid: userfield.text
    property alias password: passwordfield.text
    property alias loginbuttonmousearea: loginbuttonmousearea
    property alias errortxt: errortxt.text

    property bool passwordHide: true

    Rectangle{
        id: mainRect
        anchors.fill: parent
        Image{
            id: bckgroundimg
            anchors.fill: parent
            source: "/custom/img/Background.png"
        }
        Rectangle{
            id: userloginRect
            width: parent.width*0.4
            height: parent.height*0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*.02
            radius: 10
            border.width: 4
            border.color: qgcPal.buttonHighlight
            color: qgcPal.toolbarBackground
            visible: true
            enabled: true

            Text{
                id: userlogin
                text: "USER LOGIN"
                font.pixelSize: parent.height*.06
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height*.07
                color: qgcPal.text
                font.bold: true
            }
            Rectangle{
                width:parent.width*.65
                height: parent.height*0.004
                color: qgcPal.text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: userlogin.bottom
                anchors.topMargin: parent.height*.03
            }

            Rectangle{
                id: useridRect
                width: parent.width*.65
                height: parent.height*.17
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: parent.height*.05
                color: "transparent"
                Text {
                    text: "User ID"
                    color: qgcPal.text
                    font.pixelSize: parent.height*.26
                }
                TextField{
                    id:userfield
                    height: parent.height*.6
                    width:parent.width
                    anchors.bottom: parent.bottom
                    font.pixelSize: parent.height*.2
                    color: qgcPal.text
                    //echoMode: passwordHide ? TextInput.Password : TextInput.Normal
                    //passwordCharacter : "*"
                    placeholderText: "Enter User ID"

                    background: Rectangle {
                        color: "transparent"
                        border.width: 1
                        border.color: qgcPal.buttonHighlight
                        radius: 4
                    }
                }
            }

            Rectangle{
                id: passwordRect
                width: parent.width*.65
                height: parent.height*.17
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.verticalCenter
                anchors.topMargin: parent.height*.03
                color: "transparent"

                Text {
                    text: "Password"
                    color: qgcPal.text
                    font.pixelSize: parent.height*.26
                }
                TextField{
                    id:passwordfield
                    height: parent.height*.6
                    width:parent.width
                    anchors.bottom: parent.bottom
                    font.pixelSize: parent.height*.2
                    color: qgcPal.text
                    echoMode: passwordHide ? TextInput.Password : TextInput.Normal
                    passwordCharacter : "*"
                    placeholderText: "Enter Password"

                    background: Rectangle {
                        color: "transparent"
                        border.width: 1
                        border.color: qgcPal.buttonHighlight
                        radius: 4
                    }
                }

                Image{
                    id: eyeIcon
                    source: passwordHide ? "/custom/img/UnhidePassword.png" : "/custom/img/HidePassword.png"
                    width: passwordfield.height*0.7
                    height: passwordfield.height*0.4
                    anchors.right: passwordfield.right
                    anchors.rightMargin: passwordfield.height*0.1
                    anchors.verticalCenter: passwordfield.verticalCenter
                    ColorOverlay{
                        anchors.fill: eyeIcon
                        source: eyeIcon
                        color:qgcPal.text
                    }

                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onPressed: {
                            eyeIcon.opacity = 0.5
                        }
                        onReleased: {
                            eyeIcon.opacity = 1
                        }

                        onClicked: {
                            passwordHide = !passwordHide
                        }
                    }
                }
            }

            Rectangle{
                id: errorrect
                width:parent.width*.65
                height: errortxt.implicitHeight
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: loginbutton.top
                anchors.bottomMargin: parent.height*.03

                Text{
                    id: errortxt
                    text: ""
                    font.pixelSize: parent.width*.04
                    color: qgcPal.colorRed
                    anchors.centerIn: parent
                }
            }

            Rectangle{
                id: loginbutton
                color: qgcPal.text
                width: parent.width*0.24
                height: parent.width*0.08
                radius: 6
                border.color: qgcPal.windowShade
                border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height*.1

                Text{
                    id: buttontxt
                    text: "LOGIN"
                    font.pixelSize: parent.height*0.4
                    anchors.centerIn: parent
                    font.bold: true
                    color: qgcPal.toolbarBackground
                }

                MouseArea{
                    id: loginbuttonmousearea
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent

                    onPressed: {
                        loginbutton.opacity = 0.5
                    }
                    onReleased: {
                        loginbutton.opacity = 1
                    }
                }
            }
        }

        // Rectangle{
        //     id: logReg
        //     width : parent.width * 0.1
        //     height: parent.height *0.06
        //     color: "lightgrey"
        //     radius: 6
        //     anchors.right: parent.right
        //     anchors.bottom: parent.bottom
        //     anchors.rightMargin: parent.height*.01
        //     anchors.bottomMargin: parent.height*.01

        //     Text{
        //         id: logRegTxt
        //         text: "Register"
        //         font.pixelSize: parent.height*.3
        //         anchors.centerIn: parent
        //         font.bold: true
        //     }

        //     MouseArea{
        //         anchors.fill: parent
        //         onClicked: {
        //             if(logRegTxt.text == "Register"){
        //                 userloginRect.visible = false
        //                 userloginRect.enabled = false
        //                 userregisterRect.visible = true
        //                 userregisterRect.enabled = true
        //                 logRegTxt.text = "Login"
        //             }else if(logRegTxt.text == "Login"){
        //                 userregisterRect.visible = false
        //                 userregisterRect.enabled = false
        //                 userloginRect.visible = true
        //                 userloginRect.enabled = true
        //                 logRegTxt.text = "Register"
        //             }
        //         }

        //         onPressed: {
        //             logReg.opacity = 0.5
        //         }

        //         onReleased: {
        //             logReg.opacity = 1
        //         }
        //     }
        // }

        // Rectangle{
        //     id: userregisterRect
        //     width: parent.width*0.5
        //     height: parent.height*0.6
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.bottom: parent.bottom
        //     anchors.bottomMargin: parent.height*.02
        //     radius: 10
        //     border.width: 4
        //     border.color: "darkgrey"
        //     color: qgcPal.window
        //     visible: false
        //     enabled: false

        //     Text{
        //         id: userregister
        //         text: "USER REGISTRATION"
        //         font.pixelSize: parent.height*.06
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         anchors.top: parent.top
        //         anchors.topMargin: parent.height*.07
        //         color: "lightgrey"
        //         font.bold: true
        //     }
        //     Rectangle{
        //         width:parent.width*.6
        //         height: parent.height*0.005
        //         color: "lightgrey"
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         anchors.top: userregister.bottom
        //         anchors.topMargin: parent.height*.03
        //     }

        //     Rectangle{
        //         id: useridRegRect
        //         width: parent.width*.6
        //         height: parent.height*.17
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         anchors.bottom: parent.verticalCenter
        //         anchors.bottomMargin: parent.height*.065
        //         color: "transparent"
        //         Text {
        //             text: "User ID"
        //             color: "lightgrey"
        //             font.pixelSize: parent.height*.26
        //         }
        //         TextField{
        //             id:userRegfield
        //             height: parent.height*.6
        //             width:parent.width
        //             anchors.bottom: parent.bottom
        //             font.pixelSize: parent.height*.2
        //             color: "lightgrey"
        //             //echoMode: passwordHide ? TextInput.Password : TextInput.Normal
        //             //passwordCharacter : "*"
        //             placeholderText: "Enter User ID"

        //             background: Rectangle {
        //                 color: "transparent"
        //                 border.width: 1
        //                 border.color: "lightgrey"
        //                 radius: 4
        //             }
        //         }
        //     }

        //     Rectangle{
        //         id: passwordRegRect
        //         width: parent.width*.6
        //         height: parent.height*.17
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         anchors.verticalCenter: parent.verticalCenter
        //         color: "transparent"

        //         Text {
        //             text: "Password"
        //             color: "lightgrey"
        //             font.pixelSize: parent.height*.26
        //         }
        //         TextField{
        //             id:passwordregfield
        //             height: parent.height*.6
        //             width:parent.width
        //             anchors.bottom: parent.bottom
        //             font.pixelSize: parent.height*.2
        //             color: "lightgrey"
        //             //echoMode: passwordHide ? TextInput.Password : TextInput.Normal
        //             //passwordCharacter : "*"
        //             placeholderText: "Enter Password"

        //             background: Rectangle {
        //                 color: "transparent"
        //                 border.width: 1
        //                 border.color: "lightgrey"
        //                 radius: 4
        //             }
        //         }
        //     }

        //     // ComboBox {
        //     //     id: comboBoxRole
        //     //     width: parent.width*.6
        //     //     height: parent.height*.17
        //     //     anchors.centerIn: parent
        //     //     background: null
        //     //     anchors.horizontalCenter: parent.horizontalCenter
        //     //     anchors.top: parent.verticalCenter
        //     //     anchors.topMargin: parent.height*.04


        //     //     model: ListModel {
        //     //         ListElement { text: "Admin" }
        //     //         ListElement { text: "Pilot" }
        //     //     }


        //     //     delegate: ItemDelegate {
        //     //         anchors.fill: parent

        //     //         contentItem:Rectangle {
        //     //             anchors.fill: parent
        //     //             color: "transparent"  // Set the background color of the item
        //     //             border.width: 1
        //     //             border.color: "lightgrey"
        //     //             radius: 4
        //     //             Text {
        //     //                 text: modelData
        //     //                 font.bold: false
        //     //                 color: "lightgrey"
        //     //                 font.pixelSize: parent.height * 0.55
        //     //                 wrapMode: Text.WordWrap
        //     //                 elide: Text.ElideRight
        //     //                 anchors.fill: parent
        //     //             }
        //     //         }

        //     //         highlighted: {
        //     //             color: "red"
        //     //         }
        //     //     }

        //     //     popup: Popup {
        //     //         id: popup
        //     //         width: platecolour.width
        //     //         height: (platecolour.height *3.05) // Adjust the height based on the number of items
        //     //         y: comboBox.height*1.05
        //     //         x: comboBox.width*(-.03)

        //     //         contentItem: ListView {
        //     //             model: comboBox.popup.visible ? comboBox.delegateModel : null
        //     //             currentIndex: comboBox.visualFocus ? comboBox.currentIndex : -1
        //     //             clip: true
        //     //         }

        //     //         background: Rectangle {
        //     //             color: "white"
        //     //             radius: parent.height*.11
        //     //         }
        //     //     }

        //     //     currentIndex: 0
        //     //     onActivated: {
        //     //         console.log("Selected:", model.get(currentIndex).text);
        //     //         langSelected = model.get(currentIndex).text;
        //     //         // Perform actions based on the selected option
        //     //     }

        //     //     // Display the selected data
        //     //     contentItem: Rectangle{
        //     //         id: maintxtfield
        //     //         anchors.verticalCenter: parent.verticalCenter
        //     //         anchors.left: parent.left
        //     //         anchors.leftMargin: parent.width*.01
        //     //         width: platecolour.width*.81
        //     //         height: platecolour.height
        //     //         color: "white"

        //     //         Text {
        //     //             id: platecolourfield
        //     //             text: comboBox.currentText
        //     //             anchors.left: maintxtfield.left
        //     //             anchors.leftMargin: maintxtfield.width*.06
        //     //             anchors.top: maintxtfield.top
        //     //             anchors.topMargin: maintxtfield.height*.2
        //     //             color: "#2699E5"
        //     //             font.pixelSize: platecolour.height * 0.49
        //     //             anchors.fill: maintxtfield
        //     //             elide: Text.ElideRight

        //     //             wrapMode: Text.WordWrap
        //     //         }
        //     //         MouseArea{
        //     //             anchors.fill: parent
        //     //             onClicked: {
        //     //                 vehicleplatefield.focus = false
        //     //                 providanceidfield.focus = false
        //     //                 cityidfield.focus = false
        //     //                 menufectureridfield.focus = false
        //     //                 terminalidfield.focus = false
        //     //                 terminalphonefield.focus = false
        //     //                 terminaltypefield.focus = false
        //     //                 vehiclevinfield.focus = false
        //     //                 ignitionDelayfield.focus = false
        //     //                 gpsintervalfield.focus = false
        //     //                 canintervalfield.focus = false
        //     //                 speedlimitfield.focus = false
        //     //                 busidletimefield.focus = false
        //     //                 Qt.inputMethod.hide()
        //     //             }
        //     //         }
        //     //     }
        //     // }


        //     Rectangle{
        //         id: errorregrect
        //         width:parent.width*.6
        //         height: errorregtxt.implicitHeight
        //         color: "transparent"
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         anchors.bottom: registerbutton.top
        //         anchors.bottomMargin: parent.height*.03

        //         Text{
        //             id: errorregtxt
        //             text: ""
        //             font.pixelSize: parent.width*.04
        //             color: "red"
        //             anchors.centerIn: parent
        //         }
        //     }



        //     Rectangle{
        //         id: registerbutton
        //         color: "lightgrey"
        //         width: parent.width*0.24
        //         height: parent.width*0.08
        //         radius: 6
        //         border.color: qgcPal.windowShade
        //         border.width: 2
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         anchors.bottom: parent.bottom
        //         anchors.bottomMargin: parent.height*.1

        //         Text{
        //             id: regbuttontxt
        //             text: "LOGIN"
        //             font.pixelSize: parent.height*0.4
        //             anchors.centerIn: parent
        //             font.bold: true
        //         }

        //         MouseArea{
        //             id: regbuttonmousearea
        //             anchors.fill: parent

        //             onPressed: {
        //                 registerbutton.opacity = 0.5
        //             }
        //             onReleased: {
        //                 registerbutton.opacity = 1
        //             }
        //         }
        //     }
        // }

    }
}
