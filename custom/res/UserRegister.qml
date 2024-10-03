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
    property alias regUserid: userRegfield.text
    property alias regPassword: passwordregfield.text
    property alias submitbuttonmousearea: submitbuttonmousearea
    property alias closebuttonmousearea: closebuttonmousearea
    property alias errorfieldtxt: errorregtxt.text
    property alias combobox: rolecombobox
    property alias submitbuttontxt: submitbuttontxt
    property alias heading:headingtxt.text
    property alias bgrect: bgrect.border.color

    property bool passwordHide: true
    property bool passwordValid: false

    Rectangle{
        id: mainRect
        anchors.fill: parent
        color:"transparent"
        Rectangle{
            id: userregisterRect
            width: parent.width*0.4
            height: parent.height*0.75
            anchors.centerIn: parent
            radius: 10
            border.width: 4
            border.color: "darkgrey"
            color: qgcPal.window

            Text{
                id: headingtxt
                text: "USER REGISTRATION"
                font.pixelSize: parent.height*.04
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height*.06
                color: "lightgrey"
                font.bold: true
            }
            Rectangle{
                width:parent.width*.6
                height: parent.height*0.005
                color: "lightgrey"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: headingtxt.bottom
                anchors.topMargin: parent.height*.02
            }

            Rectangle{
                id: useridRegRect
                width: parent.width*.8
                height: parent.height*.14
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: parent.height*.15
                color: "transparent"
                Text {
                    text: "User ID"
                    color: "lightgrey"
                    font.pixelSize: parent.height*.26
                }
                TextField{
                    id:userRegfield
                    height: parent.height*.6
                    width:parent.width
                    anchors.bottom: parent.bottom
                    font.pixelSize: parent.height*.2
                    color: "lightgrey"
                    //echoMode: passwordHide ? TextInput.Password : TextInput.Normal
                    //passwordCharacter : "*"
                    placeholderText: "Enter User ID"

                    background: Rectangle {
                        color: "transparent"
                        border.width: 1
                        border.color: "lightgrey"
                        radius: 4
                    }
                }
            }

            Rectangle{
                id: passwordRegRect
                width: parent.width*.8
                height: parent.height*.14
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"

                Text {
                    text: "Password"
                    color: "lightgrey"
                    font.pixelSize: parent.height*.26
                }
                TextField{
                    id:passwordregfield
                    height: parent.height*.6
                    width:parent.width
                    anchors.bottom: parent.bottom
                    font.pixelSize: parent.height*.2
                    color: "lightgrey"
                    echoMode: passwordHide ? TextInput.Password : TextInput.Normal
                    passwordCharacter : "*"
                    placeholderText: "Enter Password"

                    background: Rectangle {
                        id: bgrect
                        color: "transparent"
                        border.width: 1
                        border.color: "lightgrey"
                        radius: 4
                    }

                    // onTextChanged:{

                    // }
                    onTextEdited: {
                        validation(passwordregfield.text)
                    }

                    function validation(text){
                        var regExp = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,16}$/;
                        if(passwordregfield.text!=""){
                            if(regExp.test(text)) {
                                passwordValid = true
                            }
                            else {
                                passwordValid = false}
                        }else{

                        }
                    }
                }

                Image{
                    id: eyeIcon
                    source: passwordHide ? "/custom/img/UnhidePassword.png" : "/custom/img/HidePassword.png"
                    width: passwordregfield.height*0.7
                    height: passwordregfield.height*0.4
                    anchors.right: passwordregfield.right
                    anchors.rightMargin: passwordregfield.height*0.1
                    anchors.verticalCenter: passwordregfield.verticalCenter
                    ColorOverlay{
                        anchors.fill: eyeIcon
                        source: eyeIcon
                        color:"white"
                    }

                    MouseArea{
                        anchors.fill: parent

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
                id: roleRegRect
                width: parent.width*.8
                height: parent.height*.14
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.verticalCenter
                anchors.topMargin: parent.height*.15
                color: "transparent"

                Text {
                    text: "User Role"
                    color: "lightgrey"
                    font.pixelSize: parent.height*.26
                }

                ComboBox {
                    id: rolecombobox
                    width: roleRegRect.width
                    height: roleRegRect.height*0.6

                    anchors.bottom: parent.bottom

                    model: ListModel {
                    }

                    delegate: ItemDelegate {
                        width: rolecombobox.width
                        height: rolecombobox.height

                        contentItem:Rectangle {
                            anchors.fill: parent
                            color: highlighted ? "black" : "lightgrey"  // Set the background color of the item
                            Text {
                                text: modelData
                                font.bold: false
                                color: highlighted ? "lightgrey" : "black"
                                font.pixelSize: parent.height * 0.4
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width*.05
                            }
                        }
                    }

                    currentIndex: 0
                    indicator: Image{
                        source: "/custom/img/logout.png"
                        height: parent.height*.8
                        width: parent.height*.8
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width*.01
                        rotation: rolecombobox.popup.visible ? 180 : 0

                        MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                rolecombobox.popup.visible = !rolecombobox.popup.visible
                            }
                        }
                    }

                    contentItem: Rectangle{
                        anchors.fill:parent
                        width: rolecombobox.width
                        height: rolecombobox.height
                        color: "white"
                        border.color: "black"
                        border.width: 1
                        //radius:

                        Image{
                            source: "/custom/img/ActiveUserIcn.png"
                            height: parent.height*.8
                            width: parent.height*.8
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: parent.width*.01
                            rotation: rolecombobox.popup.visible ? 180 : 0

                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    rolecombobox.popup.visible = !rolecombobox.popup.visible
                                }


                            }
                        }

                        Text {
                            text: rolecombobox.currentText
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width*.05
                            color: "black"
                            font.pixelSize: parent.height * 0.4
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                        }
                    }

                    // popup: Popup {
                    //     id: popup4
                    //     width: roleRegRect.width
                    //     height: (roleRegRect.height *2) // Adjust the height based on the number of items
                    //     y: rolecombobox.height*0.9
                    //     x: rolecombobox.width*0

                    //     //                     delegate: ItemDelegate {
                    //     //                         width: rolecombobox.width
                    //     //                         height: rolecombobox.height

                    //     contentItem:Rectangle {
                    //         anchors.fill: parent
                    //         color: highlighted ? "black" : "lightgrey"  // Set the background color of the item
                    //         // Text {
                    //         //     text: modelData
                    //         //     font.bold: false
                    //         //     color: highlighted ? "lightgrey" : "black"
                    //         //     font.pixelSize: parent.height * 0.4
                    //         //     wrapMode: Text.WordWrap
                    //         //     elide: Text.ElideRight
                    //         //     anchors.verticalCenter: parent.verticalCenter
                    //         //     anchors.left: parent.left
                    //         //     anchors.leftMargin: parent.width*.05
                    //         // }

                    //         ListView {
                    //             model: rolecombobox.popup.visible ? rolecombobox.delegateModel : null
                    //             currentIndex: rolecombobox.visualFocus ? rolecombobox.currentIndex : -1
                    //             clip: true
                    //         }
                    //     }
                    //     //}

                    //     // contentItem: ListView {
                    //     //     model: rolecombobox.popup.visible ? rolecombobox.delegateModel : null
                    //     //     currentIndex: rolecombobox.visualFocus ? rolecombobox.currentIndex : -1
                    //     //     clip: true
                    //     // }

                    //     // background: Rectangle {
                    //     //     color: "white"
                    //     // }
                    // }


                    // onActivated: {
                    //     console.log("Selected:", model.get(currentIndex).text);
                    //     langSelected = model.get(currentIndex).text;
                    //     // Perform actions based on the selected option
                    // }


                    // // MouseArea {
                    // //     anchors.fill: parent
                    // //     onClicked: {
                    // //         popup.visible = !popup.visible;
                    // //     }
                    // // }

                    // Display the selected data
                    // contentItem: Rectangle{
                    //     anchors.fill:parent
                    //     width: rolecombobox.width
                    //     height: rolecombobox.height
                    //     color: "lightgrey"

                    //     Text {
                    //         text: rolecombobox.currentText
                    //         anchors.verticalCenter: parent.verticalCenter
                    //         anchors.left: parent.left
                    //         anchors.leftMargin: parent.width*.05
                    //         color: "black"
                    //         font.pixelSize: parent.height * 0.4
                    //         elide: Text.ElideRight
                    //         wrapMode: Text.WordWrap
                    //     }

                    //     Image{
                    // source: "/custom/img/logout.png"
                    // height: parent.height*.8
                    // width: parent.height*.8
                    // anchors.verticalCenter: parent.verticalCenter
                    // anchors.right: parent.right
                    // anchors.rightMargin: parent.width*.01
                    // rotation: rolecombobox.popup.visible ? 180 : 0

                    //         MouseArea{
                    //             anchors.fill:parent
                    //             onClicked: {
                    //                 rolecombobox.popup.visible = !rolecombobox.popup.visible
                    //             }
                    //         }
                    //     }

                    //     MouseArea{
                    //         anchors.fill: parent

                    //         onClicked: {
                    //             userRegfield.focus = false
                    //             passwordregfield.focus = false
                    //         }
                    //     }
                    // }
                }


            }



            Rectangle{
                id: errorregrect
                width:parent.width*.6
                height: errorregtxt.implicitHeight
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: submitbutton.top
                anchors.bottomMargin: parent.height*.025

                Text{
                    id: errorregtxt
                    text: ""
                    font.pixelSize: parent.width*.04
                    color: "red"
                    anchors.centerIn: parent
                }
            }

            Rectangle{
                id: submitbutton
                color: "lightgrey"
                width: parent.width*0.24
                height: parent.width*0.08
                radius: 6
                border.color: qgcPal.windowShade
                border.width: 2
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: parent.width*.03
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height*.07

                Text{
                    id: submitbuttontxt
                    text: "SUBMIT"
                    font.pixelSize: parent.height*0.4
                    anchors.centerIn: parent
                    font.bold: true
                }

                MouseArea{
                    id: submitbuttonmousearea
                    anchors.fill: parent

                    onPressed: {
                        submitbutton.opacity = 0.5
                    }
                    onReleased: {
                        submitbutton.opacity = 1
                    }
                }
            }

            Rectangle{
                id: closebutton
                color: "lightgrey"
                width: parent.width*0.24
                height: parent.width*0.08
                radius: 6
                border.color: qgcPal.windowShade
                border.width: 2
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: parent.width*.03
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height*.07

                Text{
                    id: closebuttontxt
                    text: "CLOSE"
                    font.pixelSize: parent.height*0.4
                    anchors.centerIn: parent
                    font.bold: true
                }

                MouseArea{
                    id: closebuttonmousearea
                    anchors.fill: parent

                    onPressed: {
                        closebutton.opacity = 0.5
                    }
                    onReleased: {
                        closebutton.opacity = 1
                    }
                }
            }
        }

    }
}
