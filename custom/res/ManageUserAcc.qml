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
    property alias bckbuttonmousearea: bckbuttonmousearea
    property alias userdatamousearea: userdatamousearea
    property alias userrolepermmousearea: userrolepermmousearea
    property alias userinactmmousearea: userinactmmousearea

    property alias txt1: txt1
    property alias txt2: txt2
    property alias txt3: txt3
    property alias userDataRect: userDataRect
    property alias userRolePermRect: userRolePermRect
    property alias userInactRect: userInactRect
    property alias userdetails: userdetails
    property alias userroleperm: userroleperm
    property alias userinactivity: userinactivity

    Connections{
        target: userroleperm

        function onRoleUpdated(name){
            userdetails.userrolemodel.combobox.model.append({text: name})
        }

        function onRoleChanged(rowIndex,newName){
            userdetails.userrolemodel.combobox.model.setProperty(rowIndex, "text", newName);
        }
    }

    Rectangle{
        id: mainRect
        anchors.fill: parent
        color: qgcPal.windowShadeDark

        Rectangle{
            id: toolbar
            width: parent.width
            height: parent.height*.07
            color: qgcPal.windowShadeDark
            border.width: 2
            border.color: qgcPal.windowShadeDark

            Image{
                id:icon
                source: "/res/QGCLogoWhite"
                width: parent.height*0.7
                height: parent.height*0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.height*0.2
            }

            Text{
                id: heading
                text: "Manage User Accounts"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: parent.height*0.3
                font.pixelSize: parent.height*0.4
                color: qgcPal.text
            }

            Rectangle{
                id: backButton
                width: parent.height
                height: parent.height
                color: "transparent"
                anchors.right: parent.right
                anchors.rightMargin: parent.height*0.1

                Image{
                    id:home
                    source: "/custom/img/logout.png"
                    width: parent.height*0.5
                    height: parent.height*0.5
                    anchors.centerIn: parent

                    ColorOverlay{
                        anchors.fill: parent
                        source: home
                        color:qgcPal.text
                    }
                }

                MouseArea{
                    id: bckbuttonmousearea
                    anchors.fill: parent

                    onPressed: {
                        backButton.opacity = 0.5
                    }

                    onReleased: {
                        backButton.opacity = 1
                    }
                }

            }
        }

        Rectangle{
            id: main
            width: parent.width
            height: parent.height*.93
            color: qgcPal.windowShade
            border.width: 1
            border.color: qgcPal.windowShadeDark
            anchors.top: toolbar.bottom
            Column{
                id: columndata
                spacing: parent.height*0.02
                anchors.top:parent.top
                anchors.left: parent.left
                anchors.topMargin: parent.height*0.03
                anchors.rightMargin: parent.width*0.003

                Rectangle{
                    id: userDataRect
                    width: mainRect.width*0.16
                    height: mainRect.height*0.06
                    color: qgcPal.windowShade/*
                    border.color: qgcPal.windowShadeDark
                    border.width: 1*/

                    Image{
                        id:img1
                        source: "/custom/img/UserIcn.png"
                        width: parent.height*0.5
                        height: parent.height*0.5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: parent.height*0.3
                    }

                    Text{
                        id: txt1
                        text: "Users"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: img1.right
                        anchors.leftMargin: parent.height*0.3
                        font.pixelSize: parent.height*0.4
                        color: qgcPal.text
                    }

                    MouseArea{
                        id: userdatamousearea
                        anchors.fill:parent

                        onPressed: {
                            userDataRect.opacity = 0.5
                        }
                        onReleased: {
                            userDataRect.opacity = 1
                        }

                        onClicked: {
                            txt1.font.bold = true
                            txt2.font.bold = false
                            txt3.font.bold = false
                            userDataRect.color = qgcPal.buttonHighlight
                            userRolePermRect.color = qgcPal.windowShade
                            userInactRect.color = qgcPal.windowShade

                            userdetails.visible = true
                            userdetails.enabled = true
                            userroleperm.visible = false
                            userroleperm.enabled = false
                            userinactivity.visible = false
                            userinactivity.enabled = false

                        }
                    }
                }

                Rectangle{
                    id: userRolePermRect
                    width: mainRect.width*0.16
                    height: mainRect.height*0.06
                    color: qgcPal.windowShade/*
                    border.color: qgcPal.windowShadeDark
                    border.width: 1*/

                    Image{
                        id:img2
                        source: "/custom/img/RoleIcn.png"
                        width: parent.height*0.5
                        height: parent.height*0.5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: parent.height*0.3
                    }

                    Text{
                        id: txt2
                        text: "User Roles"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: img2.right
                        anchors.leftMargin: parent.height*0.3
                        font.pixelSize: parent.height*0.4
                        color: qgcPal.text
                    }

                    MouseArea{
                        id: userrolepermmousearea
                        anchors.fill:parent

                        onPressed: {
                            userRolePermRect.opacity = 0.5
                        }
                        onReleased: {
                            userRolePermRect.opacity = 1
                        }

                        onClicked: {
                            txt2.font.bold = true
                            txt1.font.bold = false
                            txt3.font.bold = false
                            userRolePermRect.color = qgcPal.buttonHighlight
                            userDataRect.color = qgcPal.windowShade
                            userInactRect.color = qgcPal.windowShade

                            userroleperm.visible = true
                            userroleperm.enabled = true
                            userdetails.visible = false
                            userdetails.enabled = false
                            userinactivity.visible = false
                            userinactivity.enabled = false
                        }
                    }
                }

                Rectangle{
                    id: userInactRect
                    width: mainRect.width*0.16
                    height: mainRect.height*0.06
                    color: qgcPal.windowShade/*
                    border.color: qgcPal.windowShadeDark
                    border.width: 1*/

                    Image{
                        id:img3
                        source: "/custom/img/InactiveTimeIcn.png"
                        width: parent.height*0.5
                        height: parent.height*0.5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: parent.height*0.3
                    }

                    Text{
                        id: txt3
                        text: "User Inactivity"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: img3.right
                        anchors.leftMargin: parent.height*0.3
                        font.pixelSize: parent.height*0.4
                        color: qgcPal.text
                    }

                    MouseArea{
                        id: userinactmmousearea
                        anchors.fill:parent

                        onPressed: {
                            userInactRect.opacity = 0.5
                        }
                        onReleased: {
                            userInactRect.opacity = 1
                        }

                        onClicked: {
                            txt3.font.bold = true
                            txt2.font.bold = false
                            txt1.font.bold = false
                            userInactRect.color = qgcPal.buttonHighlight
                            userRolePermRect.color = qgcPal.windowShade
                            userDataRect.color = qgcPal.windowShade

                            userinactivity.visible = true
                            userinactivity.enabled = true
                            userroleperm.visible = false
                            userroleperm.enabled = false
                            userdetails.visible = false
                            userdetails.enabled = false
                        }
                    }
                }


            }

        }

        UserData{
            id: userdetails
            width: parent.width*0.83
            height: parent.height*0.91
            anchors.verticalCenter: main.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width*0.006
            visible: false
            enabled: false

            onOpenpopup:{
                toolbar.enabled = false
                main.enabled = false
                toolbar.opacity = 0.8
                main.opacity = 0.8
            }

            onClosepopup:{
                toolbar.enabled = true
                main.enabled = true
                toolbar.opacity = 1
                main.opacity = 1
            }
        }

        UserRolePermMapping{
            id: userroleperm
            width: parent.width*0.83
            height: parent.height*0.91
            anchors.verticalCenter: main.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width*0.006
            visible: false
            enabled: false

            onOpenEdit: {
                toolbar.enabled = false
                main.enabled = false
                toolbar.opacity = 0.8
                main.opacity = 0.8
            }

            onCloseEdit: {
                toolbar.enabled = true
                main.enabled = true
                toolbar.opacity = 1
                main.opacity = 1
            }


        }

        UserInactivityTrack{
            id: userinactivity
            width: parent.width*0.83
            height: parent.height*0.91
            anchors.verticalCenter: main.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width*0.006
            visible: false
            enabled: false

            applybuttonmousearea.onClicked: {
                var intvl = intervalComboBox.split(" ")[0]
                console.log("INTERVAL: ",intvl)
                mainWindow.showMessageDialog("Changing Inactivity Timeout",
                                  qsTr("Are you Sure to change inactivity timeout to "+intvl+" minutes?"),
                                  StandardButton.Yes | StandardButton.No,
                                  function() {
                                      inactivityTime = intvl
                                      opCls.handleInactiveChanged(intvl)
                                  })
            }
        }
    }

}
