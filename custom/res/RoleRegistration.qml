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
    property var flyView: []
    property var menu: []
    property var  analyzeTools: []
    property var appSetting: []
    property alias missid: missid
    property alias teleid: teleid
    property alias dashid: dashid
    property alias manaUserid: manaUserid
    property alias vehiclesetupid: vehiclesetupid
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
        if ("FlyView" in myData) {
            var flyViewArray = myData.FlyView;
            if (flyViewArray.includes("Planning")){
                missid.checked = true
            }
            if (flyViewArray.includes("Telemetry")){
                teleid.checked = true
            }
            if (flyViewArray.includes("Dashboard")){
                dashid.checked = true
            }
        }
        if("Menu" in myData){
            var menuArray = myData.Menu;
            if(menuArray.includes("ManageUsers")){
                manaUserid.checked = true
            }
            if(menuArray.includes("VehicleSetup")){
                vehiclesetupid.checked = true
            }
            if(menuArray.includes("AnalyzeTools")){
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
            if(menuArray.includes("AppSettings")){
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
        if(missid.checked == true){
            flyView.push("Planning")
        }
        if(teleid.checked == true){
            flyView.push("Telemetry")
        }
        if(dashid.checked == true){
            flyView.push("Dashboard")
        }
        if(manaUserid.checked==true){
            menu.push("ManageUsers")
        }
        if(vehiclesetupid.checked==true){
            menu.push("VehicleSetup")
        }
        if(parentBox.checkState==1 || parentBox.checkState==2){
            menu.push("AnalyzeTools")
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
        if(parentBox2.checkState==1 || parentBox2.checkState==2){
            menu.push("AppSettings")
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
        maincontainer.push(roleidfield.text)
        maincontainer.push(rolenamefield.text);
        maincontainer.push(descpfield.text);
        maincontainer.push(flyView);
        maincontainer.push(menu);
        maincontainer.push(analyzeTools);
        maincontainer.push(appSetting);
    }

    function uncheckPerm(){
        missid.checked = false
        teleid.checked = false
        dashid.checked = false
        manaUserid.checked = false
        vehiclesetupid.checked = false
        parentBox.checkState = 0
        parentBox2.checkState = 0
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
                    contentHeight: parent.height*3
                    width: parent.width


                    Text{
                        id: headingtxt
                        text: "USER ROLE REGISTRATION"
                        font.pixelSize: parent.height*.015
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: parent.height*.02
                        color: qgcPal.text
                        font.bold: true
                    }
                    Rectangle{
                        id: line
                        width:parent.width*.6
                        height: parent.width*0.001
                        color: qgcPal.text
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: headingtxt.bottom
                        anchors.topMargin: parent.height*.013
                    }

                    Rectangle{
                        id: roleidRect
                        width: parent.width*.7
                        height: parent.height*.05
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: line.bottom
                        anchors.topMargin: parent.height*.013
                        color: "transparent"
                        Text {
                            text: "Role ID"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.27
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
                        height: parent.height*.05
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: roleidRect.bottom
                        anchors.topMargin: parent.height*.013
                        color: "transparent"

                        Text {
                            text: "Role Name"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.27
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
                        height: parent.height*.05
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: rolenameRect.bottom
                        anchors.topMargin: parent.height*.013
                        color: "transparent"

                        Text {
                            text: "Description"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.27
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
                        height: parent.height*.5
                        anchors.left: roledescpRect.left
                        anchors.top: roledescpRect.bottom
                        anchors.topMargin: parent.height*.013
                        color: "transparent"

                        Text {
                            id: permTxt
                            text: "Permissions"
                            color: qgcPal.text
                            font.pixelSize: parent.height*.033
                        }

                        Row {
                            id:col1
                            anchors.top: permTxt.bottom
                            anchors.left: parent.left
                            anchors.leftMargin: parent.height*0.04
                            anchors.topMargin: 10
                            spacing: parent.width*0.12
                            Column{
                                CheckBox {
                                    id:missid
                                    checked: false
                                    text: qsTr("Mission Planning")
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:teleid
                                    checked: false
                                    text: qsTr("Telemetry data")
                                    font.pixelSize: parent.height*0.03


                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:dashid
                                    checked: false
                                    text: qsTr("Dashboard")
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }

                                }
                                CheckBox {
                                    id:manaUserid
                                    checked: false
                                    text: qsTr("Manage Users")
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:vehiclesetupid
                                    checked: false
                                    text: qsTr("Vehicle Setup")
                                    font.pixelSize: parent.height*0.03
                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
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
                                        text: qsTr("Analyze Tools")
                                        checkState: childGroup.checkState
                                        font.pixelSize: parent.height*0.03
                                        onCheckStateChanged: {
                                            console.log(parentBox.checkState)
                                            console.log(parentBox.checked)
                                            console.log("hiiii.............")
                                        }

                                        // checked: col1child1.checked && col1child2.checked && col1child3.checked && col1child4.checked && col1child5.checked && col1child6.checked
                                        //            onCheckedChanged: {
                                        //                col1child1.checked = checked;
                                        //                col1child2.checked = checked;
                                        //                col1child3.checked = checked;
                                        //                col1child4.checked = checked;
                                        //                col1child5.checked = checked;
                                        //                col1child6.checked = checked;
                                        //            }
                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            // opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + parent.spacing
                                        }
                                    }

                                    CheckBox {
                                        id:col1child1
                                        text: qsTr("LogDownLoad")
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        font.pixelSize: parent.height*0.03

                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            // opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + parent.spacing
                                        }
                                    }

                                    CheckBox {
                                        id:col1child2
                                        text: qsTr("GeoTag")
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        font.pixelSize: parent.height*0.03

                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            // opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + parent.spacing
                                        }
                                    }
                                    CheckBox {
                                        id:col1child3
                                        text: qsTr("MavConsole")
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        font.pixelSize: parent.height*0.03

                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            // opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + parent.spacing
                                        }
                                    }
                                    CheckBox {
                                        id:col1child4
                                        text: qsTr("MavInsp")
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        font.pixelSize: parent.height*0.03

                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            // opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + parent.spacing
                                        }
                                    }
                                    CheckBox {
                                        id:col1child5
                                        text: qsTr("Vibration")
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        font.pixelSize: parent.height*0.03

                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            // opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + parent.spacing
                                        }
                                    }
                                    CheckBox {
                                        id:col1child6
                                        text: qsTr("ActivityLogs")
                                        leftPadding: indicator.width
                                        ButtonGroup.group: childGroup
                                        font.pixelSize: parent.height*0.03

                                        contentItem: Text {
                                            text: parent.text
                                            font: parent.font
                                            // opacity: enabled ? 1.0 : 0.3
                                            color: qgcPal.text
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: parent.indicator.width + parent.spacing
                                        }
                                    }
                                }

                            }



                            Column {

                                ButtonGroup {
                                    id: col2childid
                                    exclusive: false
                                    checkState: parentBox2.checkState
                                }

                                CheckBox {
                                    id: parentBox2
                                    text: qsTr("Application settings")
                                    checkState: col2childid.checkState
                                    font.pixelSize: parent.height*0.03

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

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }

                                CheckBox {
                                    id:col2child1
                                    text: qsTr("General")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }

                                CheckBox {
                                    id:col2child2
                                    text: qsTr("CommLinks")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:col2child3
                                    text: qsTr("OfflineMaps")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:col2child4
                                    text: qsTr("MavLink")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03
                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }

                                CheckBox {
                                    id:col2child5
                                    text: qsTr("RemoteID")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:col2child6
                                    text: qsTr("Console")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:col2child7
                                    text: qsTr("Help")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:col2child8
                                    text: qsTr("MockLink")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:col2child9
                                    text: qsTr("Debug")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
                                    }
                                }
                                CheckBox {
                                    id:col2child10
                                    text: qsTr("PaletteTest")
                                    leftPadding: indicator.width
                                    ButtonGroup.group: col2childid
                                    font.pixelSize: parent.height*0.03

                                    contentItem: Text {
                                        text: parent.text
                                        font: parent.font
                                        // opacity: enabled ? 1.0 : 0.3
                                        color: qgcPal.text
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: parent.indicator.width + parent.spacing
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
                        width: parent.width*0.22
                        height: parent.width*0.05
                        radius: 6
                        border.color: qgcPal.windowShade
                        border.width: 2
                        anchors.left: parent.horizontalCenter
                        anchors.leftMargin: parent.width*.03
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height*.025

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
                }

                Rectangle{
                    id: closebutton
                    color: qgcPal.text
                    width: parent.width*0.22
                    height: parent.width*0.05
                    radius: 6
                    border.color: qgcPal.windowShade
                    border.width: 2
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: parent.width*.03
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height*.025

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




}
