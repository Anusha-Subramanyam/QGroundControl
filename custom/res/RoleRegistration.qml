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
    property alias roleID: roleidfield.text
    property alias roleName: rolenamefield.text
    property alias roleDescp: descpfield.text
    property alias submitbuttonmousearea: submitbuttonmousearea
    property alias closebuttonmousearea: closebuttonmousearea
    property alias errorfieldtxt: errorregtxt.text
    property alias submitbuttontxt: submitbuttontxt
    property alias heading:headingtxt.text

    property var  maincontainer: []
    property var menu: []
    property var gcs: []
    property var  analyzeTools: []
    property var appSetting: []
    property alias missid: missid
    property alias teleid: teleid
    property alias usersid: usersid
    property alias rolesid: rolesid
    property alias vehiclesetupid: vehiclesetupid
    property alias inactid: inactid
    property alias parentBox: parentBox
    property alias col1child1: col1child1
    property alias col1child2: col1child2
    property alias col1child3: col1child3
    property alias col1child4: col1child4
    property alias col1child5: col1child5
    property alias col1child6: col1child6
    property alias parentBox2: parentBox2
    property alias col2child1: col2child1
    property alias col2child2: col2child2
    property alias col2child3: col2child3
    property alias col2child4: col2child4
    property alias col2child5: col2child5
    property alias col2child6: col2child6
    property alias col2child7: col2child7
    property alias col2child8: col2child8
    property alias col2child9: col2child9
    property alias col2child10: col2child10

    property alias flick: flickable.contentY

    function editRoleJson(myData){
        uncheckPerm()
        if ("Menu" in myData) {
            var menuArray = myData.Menu;
            if (menuArray.includes("Users")){
                usersid.checked = true
            }
            if (menuArray.includes("UserRoles")){
                rolesid.checked = true
            }
            if (menuArray.includes("InactivitySettings")){
                inactid.checked = true
            }
        }
        if("GCS" in myData){
            var gcsArray = myData.GCS;
            if(gcsArray.includes("Planning")){
                missid.checked = true
            }
            if (gcsArray.includes("Telemetry")){
                teleid.checked = true
            }
            if(gcsArray.includes("VehicleSetup")){
                vehiclesetupid.checked = true
            }
            if(gcsArray.includes("AnalyzeTools")){
                var analyzeArray = myData.AnalyzeTools;
                if("AnalyzeTools" in myData){
                    if(analyzeArray.includes("LogDownLoad")){
                        col1child1.checked = true
                    }
                    if(analyzeArray.includes("GeoTag")){
                        col1child2.checked = true
                    }
                    if(analyzeArray.includes("MavConsole")){
                        col1child3.checked = true
                    }
                    if(analyzeArray.includes("MavInsp")){
                        col1child4.checked = true
                    }
                    if(analyzeArray.includes("Vibration")){
                        col1child5.checked = true
                    }
                    if(analyzeArray.includes("ActivityLogs")){
                        col1child6.checked = true
                    }
                }
            }
            if(gcsArray.includes("AppSettings")){
                var applicationArray = myData.AppSettings;
                if("AppSettings" in myData){
                    if(applicationArray.includes("General")){
                        col2child1.checked = true
                    }
                    if(applicationArray.includes("CommLinks")){
                        col2child2.checked = true
                    }
                    if(applicationArray.includes("OfflineMaps")){
                        col2child3.checked = true
                    }
                    if(applicationArray.includes("MavLink")){
                        col2child4.checked = true
                    }
                    if(applicationArray.includes("RemoteID")){
                        col2child5.checked = true
                    }
                    if(applicationArray.includes("Console")){
                        col2child6.checked = true
                    }
                    if(applicationArray.includes("Help")){
                        col2child7.checked = true
                    }
                    if(applicationArray.includes("MockLink")){
                        col2child8.checked = true
                    }
                    if(applicationArray.includes("Debug")){
                        col2child9.checked = true
                    }
                    if(applicationArray.includes("PaletteTest")){
                        col2child10.checked = true
                    }
                }
            }
        }
    }

    function formRoleJson(){
        gcs = []
        menu = []
        analyzeTools = []
        appSetting = []
        menu = ["Dashboard","GCS"]
        if(missid.checked == true){
            gcs.push("Planning")
        }
        if(teleid.checked == true){
            gcs.push("Telemetry")
        }
        if(usersid.checked == true){
            menu.push("Users")
        }
        if(rolesid.checked==true){
            menu.push("UserRoles")
        }
        if(vehiclesetupid.checked==true){
            gcs.push("VehicleSetup")
        }
        if(parentBox.checkState==1 || parentBox.checkState==2){
            gcs.push("AnalyzeTools")
            if(parentBox.checkState==2){
                analyzeTools.push("LogDownLoad")
                analyzeTools.push("GeoTag")
                analyzeTools.push("MavConsole")
                analyzeTools.push("MavInsp")
                analyzeTools.push("Vibration")
                analyzeTools.push("ActivityLogs")
            }
            if(parentBox.checkState!=2){

                if(col1child1.checked){
                    analyzeTools.push("LogDownLoad")
                }
                if(col1child2.checked){
                    analyzeTools.push("GeoTag")
                }
                if(col1child3.checked){
                    analyzeTools.push("MavConsole")
                }
                if(col1child4.checked){
                    analyzeTools.push("MavInsp")
                }
                if(col1child5.checked){
                    analyzeTools.push("Vibration")
                }
                if(col1child6.checked){
                    analyzeTools.push("ActivityLogs")
                }
            }
        }
        if(inactid.checked==true){
            menu.push("InactivitySettings")
        }
        if(parentBox2.checkState==1 || parentBox2.checkState==2){
            gcs.push("AppSettings")
            if(parentBox2.checkState==2){
                appSetting.push("General")
                appSetting.push("CommLinks")
                appSetting.push("OfflineMaps")
                appSetting.push("MavLink")
                appSetting.push("RemoteID")
                appSetting.push("Console")
                appSetting.push("Help")
                appSetting.push("MockLink")
                appSetting.push("Debug")
                appSetting.push("PaletteTest")
            }

            if(parentBox2.checkState!=2){
                if(col2child1.checked){
                    appSetting.push("General")
                }
                if(col2child2.checked){
                    appSetting.push("CommLinks")
                }
                if(col2child3.checked){
                    appSetting.push("OfflineMaps")
                }
                if(col2child4.checked){
                    appSetting.push("MavLink")
                }
                if(col2child5.checked){
                    appSetting.push("RemoteID")
                }
                if(col2child6.checked){
                    appSetting.push("Console")
                }
                if(col2child7.checked){
                    appSetting.push("Help")
                }
                if(col2child8.checked){
                    appSetting.push("MockLink")
                }
                if(col2child9.checked){
                    appSetting.push("Debug")
                }
                if(col2child10.checked){
                    appSetting.push("PaletteTest")
                }
            }
        }
        maincontainer = []
        maincontainer.push(roleidfield.text)
        maincontainer.push(rolenamefield.text);
        maincontainer.push(descpfield.text);
        maincontainer.push(menu);
        maincontainer.push(gcs);
        maincontainer.push(analyzeTools);
        maincontainer.push(appSetting);
    }

    function uncheckPerm(){
        missid.checked = false
        teleid.checked = false
        usersid.checked = false
        rolesid.checked = false
        vehiclesetupid.checked = false
        inactid.checked = false
        parentBox.checked = false
        parentBox2.checked = false
    }

    Rectangle{
        id: mainRect
        anchors.fill: parent
        color:"transparent"
        Rectangle{
            id: userregisterRect
            width: parent.width*0.6
            height: parent.height*0.75
            anchors.centerIn: parent
            radius: 10
            border.width: 1
            border.color: qgcPal.buttonHighlight
            color: qgcPal.toolbarBackground

            ScrollView{
                id:frame
                anchors.fill: parent
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn


                Flickable{
                    id: flickable
                    contentHeight: parent.height*1.8
                    width: parent.width


                    Text{
                        id: headingtxt
                        text: "USER ROLE REGISTRATION"
                        font.pixelSize: parent.height*.025
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: parent.height*.02
                        color: qgcPal.text
                        font.bold: true
                    }
                    Rectangle{
                        id: line
                        width:parent.width*.6
                        height: parent.width*0.0018
                        color: qgcPal.text
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: headingtxt.bottom
                        anchors.topMargin: parent.height*.013
                    }

                    Rectangle{
                        id: roleidRect
                        width: parent.width*.7
                        height: parent.height*.08
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: line.bottom
                        anchors.topMargin: parent.height*.013
                        color: "transparent"
                        Text {
                            text: "Role ID"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.3
                        }
                        TextField{
                            id:roleidfield
                            height: parent.height*.6
                            width:parent.width
                            anchors.bottom: parent.bottom
                            font.pixelSize: parent.height*.2
                            color: qgcPal.text
                            //echoMode: passwordHide ? TextInput.Password : TextInput.Normal
                            //passwordCharacter : "*"
                            placeholderText: "Enter Role ID"

                            background: Rectangle {
                                color: "transparent"
                                border.width: 1
                                border.color: qgcPal.buttonHighlight
                                radius: 4
                            }
                        }
                    }

                    Rectangle{
                        id: rolenameRect
                        width: parent.width*.7
                        height: parent.height*.08
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: roleidRect.bottom
                        anchors.topMargin: parent.height*.013
                        color: "transparent"

                        Text {
                            text: "Role Name"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.3
                        }
                        TextField{
                            id:rolenamefield
                            height: parent.height*.6
                            width:parent.width
                            anchors.bottom: parent.bottom
                            font.pixelSize: parent.height*.2
                            color: qgcPal.text
                            placeholderText: "Enter Role Name"

                            background: Rectangle {
                                id: bgrect
                                color: "transparent"
                                border.width: 1
                                border.color: qgcPal.buttonHighlight
                                radius: 4
                            }


                        }

                    }

                    Rectangle{
                        id: roledescpRect
                        width: parent.width*.7
                        height: parent.height*.08
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: rolenameRect.bottom
                        anchors.topMargin: parent.height*.013
                        color: "transparent"

                        Text {
                            text: "Description"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.3
                        }

                        TextField{
                            id:descpfield
                            height: parent.height*.6
                            width:parent.width
                            anchors.bottom: parent.bottom
                            font.pixelSize: parent.height*.2
                            color: qgcPal.text
                            //echoMode: passwordHide ? TextInput.Password : TextInput.Normal
                            //passwordCharacter : "*"
                            placeholderText: "Enter Description"

                            background: Rectangle {
                                color: "transparent"
                                border.width: 1
                                border.color: qgcPal.buttonHighlight
                                radius: 4
                            }
                        }

                    }

                    Rectangle{
                        id: roleperm
                        width: parent.width*.82
                        height: parent.height*.3
                        anchors.left: roledescpRect.left
                        anchors.top: roledescpRect.bottom
                        anchors.topMargin: parent.height*.01
                        color: "transparent"

                        Text {
                            id: permTxt
                            text: "Permissions"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.08
                        }

                        Row {
                            id:col1
                            anchors.top: permTxt.bottom
                            anchors.left: parent.left
                            anchors.leftMargin: parent.height*0.04
                            anchors.topMargin: 10
                            spacing: parent.width*0.2
                            Column{
                                CheckBox {
                                    id: missid
                                      text: qsTr("Mission Planning")
                                      font.pixelSize: roleperm.width*0.025
                                      checked: false

                                      indicator: Rectangle {
                                          id:checkboxrect1
                                          implicitWidth: roleperm.width*0.04
                                          implicitHeight:roleperm.width*0.04
                                          x: missid.leftPadding
                                          y: parent.height / 2 - height / 2
                                          radius: 3
                                          border.color: qgcPal.buttonHighlight

                                          Rectangle {
                                              id:innerrect
                                              width:  checkboxrect1.width/2+1
                                              height:  checkboxrect1.width/2+1
                                              x: innerrect.width/2 - 1
                                              y: innerrect.width/2 - 1
                                              radius: 2
                                              color: qgcPal.buttonHighlight
                                              visible: missid.checked
                                          }
                                      }

                                      contentItem: Text {
                                          text: missid.text
                                          font: missid.font
                                          // font.pixelSize: missid.width*0.3
                                          opacity: enabled ? 1.0 : 0.3
                                          color: qgcPal.text
                                          verticalAlignment: Text.AlignVCenter
                                          anchors.left: checkboxrect1.right
                                          anchors.leftMargin: missid.indicator.width*0.6
                                      }
                                }
                                CheckBox {
                                    id:teleid
                                    text: qsTr("Telemetry data")
                                    font.pixelSize: roleperm.width*0.025
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect2
                                        implicitWidth: roleperm.width*0.04
                                        implicitHeight:roleperm.width*0.04
                                        x: teleid.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect2
                                            width:  checkboxrect2.width/2+1
                                            height:  checkboxrect2.width/2+1
                                            x: innerrect2.width/2 - 1
                                            y: innerrect2.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: teleid.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: teleid.text
                                        font: teleid.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect2.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:usersid
                                    checked: false
                                    text: qsTr("User Management")
                                    font.pixelSize: roleperm.width*0.025

                                    indicator: Rectangle {
                                       id: checkboxrect3
                                        implicitWidth: roleperm.width*0.04
                                        implicitHeight:roleperm.width*0.04
                                        x: usersid.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect3
                                            width:  checkboxrect3.width/2 + 1
                                            height:  checkboxrect3.width/2 + 1
                                            x: innerrect3.width/2 - 1
                                            y: innerrect3.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: usersid.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: usersid.text
                                        font: usersid.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect3.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }

                                }
                                CheckBox {
                                    id:rolesid
                                    checked: false
                                    text: qsTr("User Role Management")
                                    font.pixelSize: roleperm.width*0.025

                                    indicator: Rectangle {
                                        id:checkboxrect4
                                        implicitWidth: roleperm.width*0.04
                                        implicitHeight:roleperm.width*0.04
                                        x: rolesid.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect4
                                            width:  checkboxrect4.width/2+1
                                            height:  checkboxrect4.width/2+1
                                            x: innerrect4.width/2 - 1
                                            y: innerrect4.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: rolesid.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: rolesid.text
                                        font: rolesid.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect4.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:vehiclesetupid
                                    text: qsTr("Vehicle Setup")
                                    font.pixelSize: roleperm.width*0.025
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect5
                                        implicitWidth: roleperm.width*0.04
                                        implicitHeight:roleperm.width*0.04
                                        x: vehiclesetupid.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect5
                                            width:  checkboxrect5.width/2+1
                                            height:  checkboxrect5.width/2+1
                                            x: innerrect5.width/2 - 1
                                            y: innerrect5.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: vehiclesetupid.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: vehiclesetupid.text
                                        font: vehiclesetupid.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect5.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }

                                Column {
                                    ButtonGroup {
                                        id: childGroup
                                        exclusive: false
                                        checkState: parentBox.checkState

                                    }

                                    CheckBox {
                                        id: parentBox
                                        checkState: childGroup.checkState
                                        text: qsTr("Analyze Tools")
                                        font.pixelSize: roleperm.width*0.025
                                        checked: false

                                        indicator: Rectangle {
                                            id:checkboxrect6
                                            implicitWidth: roleperm.width*0.04
                                            implicitHeight:roleperm.width*0.04
                                            x: parentBox.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: qgcPal.buttonHighlight

                                            Rectangle {
                                                id:innerrect6
                                                width:  checkboxrect6.width/2+1
                                                height:  checkboxrect6.width/2+1
                                                x: innerrect6.width/2 - 1
                                                y: innerrect6.width/2 - 1
                                                radius: 2
                                                color: qgcPal.buttonHighlight
                                                visible: parentBox.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: parentBox.text
                                            font: parentBox.font
                                            // font.pixelSize: missid.width*0.3
                                            opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.left: checkboxrect6.right
                                            anchors.leftMargin: missid.indicator.width*0.6
                                        }
                                    }

                                    CheckBox {
                                        id:col1child1
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        text: qsTr("LogDownLoad")
                                        font.pixelSize: roleperm.width*0.02
                                        checked: false

                                        indicator: Rectangle {
                                            id:checkboxrect7
                                            implicitWidth: roleperm.width*0.03
                                            implicitHeight:roleperm.width*0.03
                                            x: col1child1.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: qgcPal.buttonHighlight

                                            Rectangle {
                                                id:innerrect7
                                                width:  checkboxrect7.width/2+1
                                                height:  checkboxrect7.width/2+1
                                                x: innerrect7.width/2 - 1
                                                y: innerrect7.width/2 - 1
                                                radius: 2
                                                color: qgcPal.buttonHighlight
                                                visible: col1child1.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: col1child1.text
                                            font: col1child1.font
                                            // font.pixelSize: missid.width*0.3
                                            opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.left: checkboxrect7.right
                                            anchors.leftMargin: missid.indicator.width*0.6
                                        }
                                    }

                                    CheckBox {
                                        id:col1child2
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        text: qsTr("GeoTag")
                                        font.pixelSize: roleperm.width*0.02
                                        checked: false

                                        indicator: Rectangle {
                                            id:checkboxrect8
                                            implicitWidth: roleperm.width*0.03
                                            implicitHeight:roleperm.width*0.03
                                            x: col1child2.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: qgcPal.buttonHighlight

                                            Rectangle {
                                                id:innerrect8
                                                width:  checkboxrect8.width/2+1
                                                height:  checkboxrect8.width/2+1
                                                x: innerrect8.width/2 - 1
                                                y: innerrect8.width/2 - 1
                                                radius: 2
                                                color: qgcPal.buttonHighlight
                                                visible: col1child2.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: col1child2.text
                                            font: col1child2.font
                                            // font.pixelSize: missid.width*0.3
                                            opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.left: checkboxrect8.right
                                            anchors.leftMargin: missid.indicator.width*0.6
                                        }
                                    }
                                    CheckBox {
                                        id:col1child3
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        text: qsTr("MavConsole")
                                        font.pixelSize: roleperm.width*0.02
                                        checked: false

                                        indicator: Rectangle {
                                            id:checkboxrect9
                                            implicitWidth: roleperm.width*0.03
                                            implicitHeight:roleperm.width*0.03
                                            x: col1child3.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: qgcPal.buttonHighlight

                                            Rectangle {
                                                id:innerrect9
                                                width:  checkboxrect9.width/2+1
                                                height:  checkboxrect9.width/2+1
                                                x: innerrect9.width/2 - 1
                                                y: innerrect9.width/2 - 1
                                                radius: 2
                                                color: qgcPal.buttonHighlight
                                                visible: col1child3.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: col1child3.text
                                            font: col1child3.font
                                            // font.pixelSize: missid.width*0.3
                                            opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.left: checkboxrect9.right
                                            anchors.leftMargin: missid.indicator.width*0.6
                                        }
                                    }
                                    CheckBox {
                                        id:col1child4
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        text: qsTr("MavInsp")
                                        font.pixelSize: roleperm.width*0.02
                                        checked: false

                                        indicator: Rectangle {
                                            id:checkboxrect10
                                            implicitWidth: roleperm.width*0.03
                                            implicitHeight:roleperm.width*0.03
                                            x: col1child4.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: qgcPal.buttonHighlight

                                            Rectangle {
                                                id:innerrect10
                                                width:  checkboxrect10.width/2+1
                                                height:  checkboxrect10.width/2+1
                                                x: innerrect10.width/2 - 1
                                                y: innerrect10.width/2 - 1
                                                radius: 2
                                                color: qgcPal.buttonHighlight
                                                visible: col1child4.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: col1child4.text
                                            font: col1child4.font
                                            // font.pixelSize: missid.width*0.3
                                            opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.left: checkboxrect10.right
                                            anchors.leftMargin: missid.indicator.width*0.6
                                        }
                                    }
                                    CheckBox {
                                        id:col1child5
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        text: qsTr("Vibration")
                                        font.pixelSize: roleperm.width*0.02
                                        checked: false

                                        indicator: Rectangle {
                                            id:checkboxrect11
                                            implicitWidth: roleperm.width*0.03
                                            implicitHeight:roleperm.width*0.03
                                            x: col1child5.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: qgcPal.buttonHighlight

                                            Rectangle {
                                                id:innerrect11
                                                width:  checkboxrect11.width/2+1
                                                height:  checkboxrect11.width/2+1
                                                x: innerrect11.width/2 - 1
                                                y: innerrect11.width/2 - 1
                                                radius: 2
                                                color: qgcPal.buttonHighlight
                                                visible: col1child5.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: col1child5.text
                                            font: col1child5.font
                                            // font.pixelSize: missid.width*0.3
                                            opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.left: checkboxrect11.right
                                            anchors.leftMargin: missid.indicator.width*0.6
                                        }
                                    }
                                    CheckBox {
                                        id:col1child6
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        text: qsTr("ActivityLogs")
                                        font.pixelSize: roleperm.width*0.02
                                        checked: false

                                        indicator: Rectangle {
                                            id:checkboxrect12
                                            implicitWidth: roleperm.width*0.03
                                            implicitHeight:roleperm.width*0.03
                                            x: col1child6.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: qgcPal.buttonHighlight

                                            Rectangle {
                                                id:innerrect12
                                                width:  checkboxrect12.width/2+1
                                                height:  checkboxrect12.width/2+1
                                                x: innerrect12.width/2 - 1
                                                y: innerrect12.width/2 - 1
                                                radius: 2
                                                color: qgcPal.buttonHighlight
                                                visible: col1child6.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: col1child6.text
                                            font: col1child6.font
                                            // font.pixelSize: missid.width*0.3
                                            opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.left: checkboxrect12.right
                                            anchors.leftMargin: missid.indicator.width*0.6
                                        }
                                    }
                                }

                            }



                            Column {

                                CheckBox {
                                    id:inactid
                                    checked: false
                                    text: qsTr("Inactivity Settings")
                                    font.pixelSize: roleperm.width*0.025

                                    indicator: Rectangle {
                                        id:checkboxrect121
                                        implicitWidth: roleperm.width*0.04
                                        implicitHeight:roleperm.width*0.04
                                        x: inactid.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect1
                                            width:  checkboxrect121.width/2+1
                                            height:  checkboxrect121.width/2+1
                                            x: innerrect1.width/2 - 1
                                            y: innerrect1.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: inactid.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: inactid.text
                                        font: inactid.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect121.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }

                                ButtonGroup {
                                    id: col2childid
                                    exclusive: false
                                    checkState: parentBox2.checkState
                                }

                                CheckBox {
                                    id: parentBox2
                                    checkState: col2childid.checkState

                                    // checked: col2child1.checked && col2child2.checked && col2child3.checked && col2child4.checked && col2child5.checked && col2child6.checked && col2child7.checked && col2child8.checked && col2child9.checked && col2child10.checked
                                    //            onCheckedChanged: {
                                    //                col2child1.checked = checked;
                                    //                col2child2.checked = checked;
                                    //                col2child3.checked = checked;
                                    //                col2child4.checked = checked;
                                    //                col2child5.checked = checked;
                                    //                col2child6.checked = checked;
                                    //                col2child7.checked = checked;
                                    //                col2child8.checked = checked;
                                    //                col2child9.checked = checked;
                                    //                col2child10.checked = checked;
                                    //            }

                                    text: qsTr("Application settings")
                                    font.pixelSize: roleperm.width*0.025
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect13
                                        implicitWidth: roleperm.width*0.04
                                        implicitHeight:roleperm.width*0.04
                                        x: parentBox2.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect13
                                            width:  checkboxrect13.width/2+1
                                            height:  checkboxrect13.width/2+1
                                            x: innerrect13.width/2 - 1
                                            y: innerrect13.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: parentBox2.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: parentBox2.text
                                        font: parentBox2.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect13.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }

                                CheckBox {
                                    id:col2child1
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("General")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect14
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child1.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color:qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect14
                                            width:  checkboxrect14.width/2+1
                                            height:  checkboxrect14.width/2+1
                                            x: innerrect14.width/2 - 1
                                            y: innerrect14.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child1.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child1.text
                                        font: col2child1.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect14.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }

                                CheckBox {
                                    id:col2child2
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("CommLinks")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect15
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child2.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect15
                                            width:  checkboxrect15.width/2+1
                                            height:  checkboxrect15.width/2+1
                                            x: innerrect15.width/2 - 1
                                            y: innerrect15.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child2.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child2.text
                                        font: col2child2.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect15.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:col2child3
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("OfflineMaps")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect16
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child3.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect16
                                            width:  checkboxrect16.width/2+1
                                            height:  checkboxrect16.width/2+1
                                            x: innerrect16.width/2 - 1
                                            y: innerrect16.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child3.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child3.text
                                        font: col2child3.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect16.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:col2child4
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("MavLink")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect17
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child4.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect17
                                            width:  checkboxrect17.width/2+1
                                            height:  checkboxrect17.width/2+1
                                            x: innerrect17.width/2 - 1
                                            y: innerrect17.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child4.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child4.text
                                        font: col2child4.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect17.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }

                                CheckBox {
                                    id:col2child5
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("RemoteID")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect18
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child5.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect18
                                            width:  checkboxrect18.width/2+1
                                            height:  checkboxrect18.width/2+1
                                            x: innerrect18.width/2 - 1
                                            y: innerrect18.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child5.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child5.text
                                        font: col2child5.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect18.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:col2child6
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("Console")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect19
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child6.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect19
                                            width:  checkboxrect19.width/2+1
                                            height:  checkboxrect19.width/2+1
                                            x: innerrect19.width/2 - 1
                                            y: innerrect19.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child6.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child6.text
                                        font: col2child6.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect19.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:col2child7
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("Help")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect20
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child7.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect20
                                            width:  checkboxrect20.width/2+1
                                            height:  checkboxrect20.width/2+1
                                            x: innerrect20.width/2 - 1
                                            y: innerrect20.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child7.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child7.text
                                        font: col2child7.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect20.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:col2child8
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("MockLink")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect21
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child8.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect21
                                            width:  checkboxrect21.width/2+1
                                            height:  checkboxrect21.width/2+1
                                            x: innerrect21.width/2 - 1
                                            y: innerrect21.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child8.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child8.text
                                        font: col2child8.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect21.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:col2child9
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("Debug")
                                    font.pixelSize:roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect22
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child9.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color:qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect22
                                            width:  checkboxrect22.width/2+1
                                            height:  checkboxrect22.width/2+1
                                            x: innerrect22.width/2 - 1
                                            y: innerrect22.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child9.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child9.text
                                        font: col2child9.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect22.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }
                                CheckBox {
                                    id:col2child10
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    text: qsTr("Debug")
                                    font.pixelSize: roleperm.width*0.02
                                    checked: false

                                    indicator: Rectangle {
                                        id:checkboxrect23
                                        implicitWidth: roleperm.width*0.03
                                        implicitHeight:roleperm.width*0.03
                                        x: col2child10.leftPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 3
                                        border.color: qgcPal.buttonHighlight

                                        Rectangle {
                                            id:innerrect23
                                            width:  checkboxrect23.width/2+1
                                            height:  checkboxrect23.width/2+1
                                            x: innerrect23.width/2 - 1
                                            y: innerrect23.width/2 - 1
                                            radius: 2
                                            color: qgcPal.buttonHighlight
                                            visible: col2child10.checked
                                        }
                                    }

                                    contentItem: Text {
                                        text: col2child10.text
                                        font: col2child10.font
                                        // font.pixelSize: missid.width*0.3
                                        opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: checkboxrect23.right
                                        anchors.leftMargin: missid.indicator.width*0.6
                                    }
                                }

                            }

                        }


                    }



                    Rectangle{
                        id: errorregrect
                        width:parent.width*.6
                        height: errorregtxt.implicitHeight
                        color: "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height*.05

                        Text{
                            id: errorregtxt
                            text: "Hii"
                            font.pixelSize: parent.width*.04
                            color: qgcPal.colorRed
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle{
                        id: submitbutton
                        color: qgcPal.text
                        width: parent.width*0.13
                        height: parent.width*0.05
                        radius: 6
                        border.color: qgcPal.windowShadeDark
                        border.width: 2
                        anchors.left: parent.horizontalCenter
                        anchors.leftMargin: parent.width*.025
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height*.07
                        // anchors.top: roleperm.bottom
                        // // anchors.topMargin: parent.height*.003

                        Text{
                            id: submitbuttontxt
                            text: "SUBMIT"
                            font.pixelSize: parent.height*0.4
                            anchors.centerIn: parent
                            color: qgcPal.windowShadeDark
                            font.bold: true
                        }

                        MouseArea{
                            id: submitbuttonmousearea
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent

                            onPressed: {
                                submitbutton.opacity = 0.5
                            }
                            onReleased: {
                                submitbutton.opacity = 1
                            }
                        }
                    }
                }

                Rectangle{
                    id: closebutton
                    color: qgcPal.text
                   width: parent.width*0.13
                    height: parent.width*0.05
                    radius: 6
                    border.color: qgcPal.windowShadeDark
                    border.width: 2
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: parent.width*.03
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height*.07
                    // anchors.top: roleperm.bottom
                    // // anchors.topMargin: parent.height*.0008

                    Text{
                        id: closebuttontxt
                        text: "CLOSE"
                        font.pixelSize: parent.height*0.4
                        anchors.centerIn: parent
                        color: qgcPal.windowShadeDark
                        font.bold: true
                    }

                    MouseArea{
                        id: closebuttonmousearea
                        cursorShape: Qt.PointingHandCursor
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




}
