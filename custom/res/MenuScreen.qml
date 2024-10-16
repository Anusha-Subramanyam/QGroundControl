import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtGraphicalEffects 1.15

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0

Item {
    property bool drawerStatus: false
    signal gcsClicked()

    //property alias modelTimer: parametermodeltimer

    function defaultDashboardSelect(){
        //parametermodeltimer.start()
        dashtxtid.font.bold = true
        gcstxtid.font.bold = false
        usertxtid.font.bold = false
        roletxtid.font.bold = false
        inacttxtid.font.bold = false
        dashboardRect.color = qgcPal.buttonHighlight
        dashtxtid.color = qgcPal.buttonHighlightText
        gcsRect.color = "transparent"
        gcstxtid.color = qgcPal.buttonText
        usersRect.color = "transparent"
        usertxtid.color = qgcPal.buttonText
        rolesRect.color = "transparent"
        roletxtid.color = qgcPal.buttonText
        inactivityRect.color = "transparent"
        inacttxtid.color = qgcPal.buttonText

        dashboard.visible = true
        dashboard.enabled = true
        userdetails.visible = false
        userdetails.enabled = false
        userroleperm.visible = false
        userroleperm.enabled = false
        userinactivity.visible = false
        userinactivity.enabled = false
    }

    // Timer{
    //     id: parametermodeltimer
    //     repeat: true
    //     running: false
    //     interval: 200

    //     onTriggered: {
    //         dashboard.populateData()
    //     }
    // }

    Rectangle{
        id: mainRect
        color: qgcPal.toolbarBackground
        anchors.fill:parent

        Rectangle{
            id: header
            color: qgcPal.toolbarBackground
            width: parent.width
            height:  parent.height*0.1



            Rectangle{
                id: menubutton
                width: parent.height*0.75
                height: parent.height
                color: "transparent"

                Image{
                    id:menuimg
                    source: "/custom/img/optionsIcon.png"
                    width: parent.width*0.5
                    height: parent.width*0.5
                    anchors.centerIn: parent

                    ColorOverlay{
                        anchors.fill: parent
                        source: menuimg
                        color:qgcPal.text
                    }
                }

                MouseArea{
                    id: menubuttonmousearea
                    anchors.fill: parent

                    onClicked: {
                        if(drawerStatus){
                            leftdrawer.width = content.width*0.04
                        }else{
                            leftdrawer.width = content.width*0.17
                        }
                        drawerStatus = !drawerStatus
                    }

                    onPressed: {
                        menubutton.opacity = 0.5
                    }

                    onReleased: {
                        menubutton.opacity = 1
                    }
                }
            }

            // Image{
            //     id:logo
            //     source: "/custom/img/TaraLogo.png"
            //     width: parent.width*0.1
            //     height: parent.height*0.9
            //     anchors.verticalCenter: parent.verticalCenter
            //     anchors.left: menubutton.right
            //     anchors.leftMargin: parent.height*0.3

            // }

            Rectangle{
                id: logout
                width:parent.height
                height: parent.height
                color: "transparent"
                anchors.right: parent.right
                anchors.rightMargin: parent.height*0.1
                anchors.top:parent.top

                Image{
                    id: logoutimg
                    width: parent.width*0.35
                    height: parent.height*0.35
                    source: "/custom/img/logout.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: parent.height*0.2

                    ColorOverlay{
                        anchors.fill: parent
                        source: logoutimg
                        color:qgcPal.text
                    }
                }

                Text{
                    text: "Logout"
                    font.pixelSize: parent.height*0.2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height*0.15
                    color: qgcPal.text
                }

                MouseArea{
                    id: logoutmousearea
                    anchors.fill:parent
                    onPressed: {
                        logout.opacity = 0.5
                    }

                    onReleased: {
                        logout.opacity = 1
                    }

                    onClicked: {
                        if (!mainWindow.preventViewSwitch()) {
                            mainWindow.showMessageDialog(closeDialogTitle,
                                                         qsTr("Are you sure you want to Logout?"),
                                                         StandardButton.Yes | StandardButton.No,
                                                         function() {
                                                             mainWindow.logoutFlag = true
                                                             mainWindow.checkForUnsavedMission()
                                                         })
                        }
                    }
                }
            }

        }

        Rectangle{
            id: content
            color: qgcPal.toolbarBackground
            width: parent.width
            height:  parent.height*0.9
            anchors.top: header.bottom

            Rectangle{
                id: leftdrawer
                width: parent.width*0.04
                height: parent.height
                color: qgcPal.toolbarBackground

                Column{
                    spacing: parent.width*0.055
                    anchors.fill: parent
                    anchors.top: parent.top
                    anchors.topMargin: parent.height*0.03

                    Rectangle{
                        id: dashboardRect
                        height: parent.height*0.065
                        width: parent.width
                        color: qgcPal.buttonHighlight

                        Image{
                            id:img1
                            source: "/custom/img/Dashboard.png"
                            width: parent.height*0.53
                            height: parent.height*0.53
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.height*0.44

                            ColorOverlay{
                                anchors.fill: parent
                                source: img1
                                color:qgcPal.text
                            }
                        }

                        Text {
                            id: dashtxtid
                            text: qsTr("Dashboard")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: img1.right
                            anchors.leftMargin: parent.height*0.41
                            font.pixelSize: parent.height*0.36
                            font.bold: true
                            color: qgcPal.buttonHighlightText
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onHoveredChanged: {
                                if(dashtxtid.font.bold == false){
                                    if(containsMouse){
                                        dashboardRect.color = qgcPal.buttonHighlight
                                        dashtxtid.color = qgcPal.buttonHighlightText
                                    }else{
                                        dashboardRect.color = "transparent"
                                        dashtxtid.color = qgcPal.buttonText
                                    }
                                }
                            }

                            onPressed: {
                                dashboardRect.opacity = 0.5
                            }

                            onReleased: {
                                dashboardRect.opacity = 1
                            }

                            onClicked: {
                                //parametermodeltimer.start()
                                dashboard.populateData()
                                dashtxtid.font.bold = true
                                gcstxtid.font.bold = false
                                usertxtid.font.bold = false
                                roletxtid.font.bold = false
                                inacttxtid.font.bold = false
                                dashboardRect.color = qgcPal.buttonHighlight
                                dashtxtid.color = qgcPal.buttonHighlightText
                                gcsRect.color = "transparent"
                                gcstxtid.color = qgcPal.buttonText
                                usersRect.color = "transparent"
                                usertxtid.color = qgcPal.buttonText
                                rolesRect.color = "transparent"
                                roletxtid.color = qgcPal.buttonText
                                inactivityRect.color = "transparent"
                                inacttxtid.color = qgcPal.buttonText

                                dashboard.visible = true
                                dashboard.enabled = true
                                userdetails.visible = false
                                userdetails.enabled = false
                                userroleperm.visible = false
                                userroleperm.enabled = false
                                userinactivity.visible = false
                                userinactivity.enabled = false
                            }
                        }
                    }

                    Rectangle{
                        id: gcsRect
                        height: parent.height*0.065
                        width: parent.width
                        color: "transparent"

                        Image{
                            id:img2
                            source: "/custom/img/gcsIcon.png"
                            width: parent.height*0.53
                            height: parent.height*0.53
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.height*0.44
                            ColorOverlay{
                                anchors.fill: parent
                                source: img2
                                color:qgcPal.text
                            }
                        }

                        Text {
                            id: gcstxtid
                            text: qsTr("GCS")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: img2.right
                            anchors.leftMargin: parent.height*0.41
                            font.pixelSize: parent.height*0.36

                            color: qgcPal.buttonText
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onHoveredChanged: {
                                if(gcstxtid.font.bold == false){
                                    if(containsMouse){
                                        gcsRect.color = qgcPal.buttonHighlight
                                        gcstxtid.color = qgcPal.buttonHighlightText
                                    }else{
                                        gcsRect.color = "transparent"
                                        gcstxtid.color = qgcPal.buttonText
                                    }
                                }
                            }
                            onPressed: {
                                gcsRect.opacity = 0.5
                            }

                            onReleased: {
                                gcsRect.opacity = 1
                            }
                            onClicked: {
                                gcsClicked()
                                //parametermodeltimer.stop()
                            }
                        }
                    }

                    Rectangle{
                        id: usersRect
                        height: parent.height*0.065
                        width: parent.width
                        color: "transparent"

                        Image{
                            id:img3
                            source: "/custom/img/UserIcn.png"
                            width: parent.height*0.53
                            height: parent.height*0.53
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.height*0.44

                            ColorOverlay{
                                anchors.fill: parent
                                source: img3
                                color:qgcPal.text
                            }
                        }

                        Text {
                            id: usertxtid
                            text: qsTr("Users")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: img3.right
                            anchors.leftMargin: parent.height*0.41
                            font.pixelSize: parent.height*0.36

                            color: qgcPal.buttonText
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onHoveredChanged: {
                                if(usertxtid.font.bold == false){
                                    if(containsMouse){
                                        usersRect.color = qgcPal.buttonHighlight
                                        usertxtid.color = qgcPal.buttonHighlightText
                                    }else{
                                        usersRect.color = "transparent"
                                        usertxtid.color = qgcPal.buttonText
                                    }
                                }
                            }
                            onPressed: {
                                usersRect.opacity = 0.5
                            }

                            onReleased: {
                                usersRect.opacity = 1
                            }
                            onClicked: {
                                //parametermodeltimer.stop()
                                dashtxtid.font.bold = false
                                gcstxtid.font.bold = false
                                usertxtid.font.bold = true
                                roletxtid.font.bold = false
                                inacttxtid.font.bold = false
                                dashboardRect.color = "transparent"
                                dashtxtid.color = qgcPal.buttonText
                                gcsRect.color = "transparent"
                                gcstxtid.color = qgcPal.buttonText
                                usersRect.color = qgcPal.buttonHighlight
                                usertxtid.color = qgcPal.buttonHighlightText
                                rolesRect.color = "transparent"
                                roletxtid.color = qgcPal.buttonText
                                inactivityRect.color = "transparent"
                                inacttxtid.color = qgcPal.buttonText

                                dashboard.visible = false
                                dashboard.enabled = false
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
                        id: rolesRect
                        height: parent.height*0.065
                        width: parent.width
                        color: "transparent"

                        Image{
                            id:img4
                            source: "/custom/img/RoleIcn.png"
                            width: parent.height*0.53
                            height: parent.height*0.53
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.height*0.44

                            ColorOverlay{
                                anchors.fill: parent
                                source: img4
                                color:qgcPal.text
                            }
                        }

                        Text {
                            id: roletxtid
                            text: qsTr("User Roles")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: img4.right
                            anchors.leftMargin: parent.height*0.41
                            font.pixelSize: parent.height*0.36

                            color: qgcPal.buttonText
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onHoveredChanged: {
                                if(roletxtid.font.bold ==false){
                                    if(containsMouse){
                                        rolesRect.color = qgcPal.buttonHighlight
                                        roletxtid.color = qgcPal.buttonHighlightText
                                    }else{
                                        rolesRect.color = "transparent"
                                        roletxtid.color = qgcPal.buttonText
                                    }
                                }
                            }
                            onPressed: {
                                rolesRect.opacity = 0.5
                            }

                            onReleased: {
                                rolesRect.opacity = 1
                            }
                            onClicked: {
                                //parametermodeltimer.stop()
                                dashtxtid.font.bold = false
                                gcstxtid.font.bold = false
                                usertxtid.font.bold = false
                                roletxtid.font.bold = true
                                inacttxtid.font.bold = false
                                dashboardRect.color = "transparent"
                                dashtxtid.color = qgcPal.buttonText
                                gcsRect.color = "transparent"
                                gcstxtid.color = qgcPal.buttonText
                                usersRect.color = "transparent"
                                usertxtid.color = qgcPal.buttonText
                                rolesRect.color = qgcPal.buttonHighlight
                                roletxtid.color = qgcPal.buttonHighlightText
                                inactivityRect.color = "transparent"
                                inacttxtid.color = qgcPal.buttonText

                                dashboard.visible = false
                                dashboard.enabled = false
                                userdetails.visible = false
                                userdetails.enabled = false
                                userroleperm.visible = true
                                userroleperm.enabled = true
                                userinactivity.visible = false
                                userinactivity.enabled = false
                            }
                        }
                    }

                    Rectangle{
                        id: inactivityRect
                        height: parent.height*0.065
                        width: parent.width
                        color: "transparent"

                        Image{
                            id:img5
                            source: "/custom/img/InactiveTimeIcn.png"
                            width: parent.height*0.53
                            height: parent.height*0.53
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.height*0.44

                            ColorOverlay{
                                anchors.fill: parent
                                source: img5
                                color:qgcPal.text
                            }
                        }

                        Text {
                            id: inacttxtid
                            text: qsTr("Inactivity Settings")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: img5.right
                            anchors.leftMargin: parent.height*0.41
                            font.pixelSize: parent.height*0.36

                            color: qgcPal.buttonText
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onHoveredChanged: {
                                if(inacttxtid.font.bold == false){
                                    if(containsMouse){
                                        inactivityRect.color = qgcPal.buttonHighlight
                                        inacttxtid.color = qgcPal.buttonHighlightText
                                    }else{
                                        inactivityRect.color = "transparent"
                                        inacttxtid.color = qgcPal.buttonText
                                    }
                                }
                            }
                            onPressed: {
                                inactivityRect.opacity = 0.5
                            }

                            onReleased: {
                                inactivityRect.opacity = 1
                            }
                            onClicked: {
                                //parametermodeltimer.stop()
                                dashtxtid.font.bold = false
                                gcstxtid.font.bold = false
                                usertxtid.font.bold = false
                                roletxtid.font.bold = false
                                inacttxtid.font.bold = true
                                dashboardRect.color = "transparent"
                                dashtxtid.color = qgcPal.buttonText
                                gcsRect.color = "transparent"
                                gcstxtid.color = qgcPal.buttonText
                                usersRect.color = "transparent"
                                usertxtid.color = qgcPal.buttonText
                                rolesRect.color = "transparent"
                                roletxtid.color = qgcPal.buttonText
                                inactivityRect.color = qgcPal.buttonHighlight
                                inacttxtid.color = qgcPal.buttonHighlightText

                                dashboard.visible = false
                                dashboard.enabled = false
                                userdetails.visible = false
                                userdetails.enabled = false
                                userroleperm.visible = false
                                userroleperm.enabled = false
                                userinactivity.visible = true
                                userinactivity.enabled = true
                            }
                        }
                    }

                }
            }
        }
        Dashboard{
            id: dashboard
            width: (drawerStatus == true) ? content.width*0.82 : content.width*0.95
            height:content.height*0.98
            anchors.left: parent.left
            anchors.leftMargin: (drawerStatus == true) ? content.width*0.17 : content.width*0.04
            anchors.top: header.bottom
        }

        UserData{
            id: userdetails
            width: (drawerStatus == true) ? content.width*0.82 : content.width*0.95
            height: content.height*0.98
            anchors.left: parent.left
            anchors.leftMargin: (drawerStatus == true) ? content.width*0.17 : content.width*0.04
            anchors.top: header.bottom
            visible: false
            enabled: false

            onOpenpopup:{
                header.enabled = false
                content.enabled = false
                header.opacity = 0.5
                content.opacity = 0.5
            }

            onClosepopup:{
                header.enabled = true
                content.enabled = true
                header.opacity = 1
                content.opacity = 1
            }
        }

        UserRolePermMapping{
            id: userroleperm
            width: (drawerStatus == true) ? content.width*0.82 : content.width*0.95
            height:content.height*0.98
            anchors.left: parent.left
            anchors.leftMargin: (drawerStatus == true) ? content.width*0.17 : content.width*0.04
            anchors.top: header.bottom
            visible: false
            enabled: false

            onOpenEdit: {
                header.enabled = false
                content.enabled = false
                header.opacity = 0.4
                content.opacity = 0.4
            }

            onCloseEdit: {
                header.enabled = true
                content.enabled = true
                header.opacity = 1
                content.opacity = 1
            }


        }

        UserInactivityTrack{
            id: userinactivity
            width: (drawerStatus == true) ? content.width*0.82 : content.width*0.95
            height:content.height*0.98
            anchors.left: parent.left
            anchors.leftMargin: (drawerStatus == true) ? content.width*0.17 : content.width*0.04
            anchors.top: header.bottom
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
