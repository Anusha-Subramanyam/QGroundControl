import QtQuick          2.15
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls             1.4
import QtQuick.Controls 2.15

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.FlightMap     1.0

Item {
    signal droneSelected()
    QGCPalette { id: qgcPal }

     property var _activeVeh: QGroundControl.multiVehicleManager.activeVehicle
     property var sensorvalue: _activeVeh.sysStatusSensorInfo.sensorStatus
    Connections {
        target: QGroundControl.multiVehicleManager.vehicles
        onCountChanged:{
            console.log(QGroundControl.multiVehicleManager.vehicles.count)

            if(QGroundControl.multiVehicleManager.vehicles.count>0){
                popuprectid.visible = false
                popuprectid.enabled = false
            }else{
                popuprectid.visible = true
                popuprectid.enabled = true
            }

            updateactivedronelist()
        }
    }

    function updateactivedronelist(){
        console.log("In update drone list function")
        droneModel.clear()
        for (var i = 0; i < QGroundControl.multiVehicleManager.vehicles.count; i++) {
            var vehicle = QGroundControl.multiVehicleManager.vehicles.get(i)
            console.log(".............................")
            console.log("vehicle.id = ", vehicle.id)
            console.log("vehicle.firmwareTypeString = ", vehicle.firmwareTypeString)
            console.log("vehicle.vehicleTypeString = ", vehicle.vehicleTypeString)
            console.log(".............................")

            droneModel.append({vehid: vehicle.id , firmtype: vehicle.firmwareTypeString ,vehtype: vehicle.vehicleTypeString, selected: "/custom/img/DroneUnselectIcon.png"})
        }
    }
    Timer {
           id: dataTimer
           interval: 1000
           repeat: true
           running: false

           onTriggered: {
                var paramdata = []
                paramdata =  getdata()
               console.log("Timer function............................")
             if(_activeVeh){
             opCls.writeDataToFile(paramdata)
             }else{
                dataTimer.stop()
             }
             console.log("Timer stop............................")
           }
       }

    function getdata(){
        var paramList = [];
         console.log("get data............................")
        paramList.push(_activeVeh.id.toString())
        paramList.push(_activeVeh.vehicleTypeString)
        paramList.push(_activeVeh.firmwareTypeString)
        paramList.push(_activeVeh.latitude.toString())
        paramList.push(_activeVeh.longitude.toString())
        paramList.push(_activeVeh.altitudeAboveTerr.value)
        paramList.push(QGroundControl.gpsRtk.numSatellites.value)
        paramList.push(_activeVeh.gps.hdop.value)
        paramList.push(_activeVeh.heading.value)
        paramList.push(_activeVeh.airSpeed.value)
        paramList.push(_activeVeh.groundSpeed.value)
        paramList.push(_activeVeh.batteries.get(0).voltage.value)
        paramList.push(_activeVeh.batteries.get(0).current.value)
        paramList.push(_activeVeh.batteries.get(0).temperature.value)
        paramList.push(_activeVeh.batteries.get(0).percentRemaining.value)
        paramList.push(_activeVeh.flightMode.toString())
        paramList.push(_activeVeh.homePosition)
        paramList.push(_activeVeh.distanceToHome.value)
        paramList.push(_activeVeh.altitudeAboveTerr.value)
        paramList.push(_activeVeh.altitudeRelative.value)
        paramList.push(_activeVeh.rcRSSI.toString())
        paramList.push(_activeVeh.vehicleLinkManager.communicationLost.toString())
        paramList.push(sensorvalue[0])
        paramList.push(sensorvalue[1])
        paramList.push(sensorvalue[2])
        paramList.push(sensorvalue[3])
        paramList.push(sensorvalue[4])
        paramList.push(sensorvalue[5])
        paramList.push(sensorvalue[6])
        paramList.push(sensorvalue[7])
        paramList.push(sensorvalue[8])
        paramList.push(sensorvalue[9])
        paramList.push(sensorvalue[10])
        paramList.push(sensorvalue[11])
        paramList.push(sensorvalue[12])
        paramList.push(sensorvalue[13])
        paramList.push(sensorvalue[14])
        paramList.push(sensorvalue[15])
        paramList.push(sensorvalue[16])

        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("aditya")
        // paramList.push("Aditya")
        console.log("get data before return............................")
        return paramList;
    }

    Rectangle{
        id: mainRect
        color: qgcPal.windowShadeDark
        border.color: qgcPal.buttonHighlight
        anchors.fill:parent

        // border.color: qgcPal.windowShade
        border.width: 2

        Text{
            id: heading
            text: "Active Drones"
            font.pixelSize: parent.height*0.05
            color: qgcPal.text
            anchors.left: parent.left
            anchors.top:parent.top
            anchors.topMargin: parent.height*0.05
            anchors.leftMargin: parent.height*0.09
        }

        ListModel {
            id: droneModel
            // ListElement { vehid: "001"; firmtype: "PX4"; vehtype: "Quadcopter"; selected: "/custom/img/DroneUnselectIcon.png"}
            // ListElement { vehid: "002"; firmtype: "CCC"; vehtype: "www"; selected: "/custom/img/DroneUnselectIcon.png"}
            // ListElement { vehicleid: "002"; firmwaretype: "ArduPilot"; vehicletype: "Hexacopter"; selected: false }
            // ListElement { vehicleid: "003"; firmwaretype: "PX4"; vehicletype: "Octocopter"; selected: false }
            // ListElement { vehicleid: "003"; firmwaretype: "PX4"; vehicletype: "Octocopter"; selected: false }
            // ListElement { vehicleid: "003"; firmwaretype: "PX4"; vehicletype: "Octocopter"; selected: false }
        }

        TableView {
            id: tableviewcomp
            height: parent.height*.8
            width: parent.width*.92
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.02
            backgroundVisible: false
            frameVisible: false
            verticalScrollBarPolicy: ScrollBar.AlwaysOff
            horizontalScrollBarPolicy: ScrollBar.AlwaysOff

            model: droneModel

            TableViewColumn {
                role: "vehid"
                title: "Vehicle ID"
                width: tableviewcomp.width*.25

                delegate: Item {
                    Rectangle {
                        width: parent.width
                        height: parent.height*.64
                        color: "transparent"
                        radius: parent.height*.1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.1
                            text: model ? model.vehid : ""
                            font {
                                pixelSize: parent.height*.7
                                bold: false
                            }
                            color: qgcPal.text
                            clip: true
                            anchors.centerIn: parent
                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap

                        }
                    }
                }
            }

            TableViewColumn {
                role: "firmtype"
                title: "Firmware Type"
                width: tableviewcomp.width*.25

                delegate: Item {
                    Rectangle {
                        width: parent.width
                        height: parent.height*.64
                        color: "transparent"
                        radius: parent.height*.1
                        anchors.verticalCenter: parent.verticalCenter
                        // property var    _vehicle:   object

                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.1
                            text: model ? model.firmtype : ""
                            font {
                                pixelSize: parent.height*.7
                                bold: false
                            }
                            color: qgcPal.text
                            clip: true
                            anchors.centerIn: parent
                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap

                        }
                    }
                }
            }
            TableViewColumn {
                role: "vehtype"
                title: "Vehicle Type"
                width: tableviewcomp.width*.25

                delegate: Item {
                    Rectangle {
                        width: parent.width
                        height: parent.height*.64
                        color: "transparent"
                        radius: parent.height*.1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.1
                            text: model ? model.vehtype : ""
                            font {
                                pixelSize: parent.height*.7
                                bold: false
                            }
                            color: qgcPal.text
                            clip: true
                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap
                            anchors.centerIn: parent
                        }
                    }
                }
            }


            TableViewColumn {
                role: "selected"
                title: "Selected"
                width: tableviewcomp.width*.25

                delegate: Item {
                    Rectangle {
                        id:rectdel
                        width: parent.width
                        height: parent.height*.64
                        color: "transparent"
                        radius: parent.height*.1
                        anchors.verticalCenter: parent.verticalCenter


                        Image{
                            id: userprofileimg
                            width: parent.height*0.9
                            height: parent.height*0.9
                            source: model.selected
                            anchors.centerIn: parent


                            ColorOverlay{
                                id:coloroverid
                                anchors.fill: parent
                                source: userprofileimg
                                color:"transparent"
                            }
                        }
                    }
                }
            }

            // TableViewColumn {
            //     role: "underline"
            //     title: "underline"
            //     width: tableviewcomp.width

            //     delegate: Item {
            //         Rectangle {
            //             width: parent.width*5
            //             height: parent.height*.04
            //             x: parent.width*(-1.5)
            //             y: parent.height*(-.15)
            //             color: "transparent"
            //             radius: parent.height*.1

            //             Image {
            //                 source: "/custom/img/UnderLineIcon.svg"
            //                 height: parent.height*.85
            //                 width: parent.width
            //                 anchors.centerIn: parent

            //                 ColorOverlay{
            //                     anchors.fill: parent
            //                     source: parent
            //                     color:qgcPal.buttonHighlight
            //                 }
            //             }
            //         }
            //     }
            // }


            headerDelegate: Rectangle {
                height: tableviewcomp.height*0.1
                width: tableviewcomp.width
                color: "transparent"

                Rectangle{
                    id:rect1
                    height: parent.height
                    width: tableviewcomp.width*0.25
                    anchors.left: parent.left
                    color: qgcPal.buttonHighlight
                    border.color:qgcPal.toolbarBackground
                    // anchors.leftMargin:tableviewcomp.width*0.05

                    Text {
                        id: vechidtxt
                        text: qsTr("Vehicle ID")
                        color: qgcPal.text
                        anchors.centerIn: parent
                        font.pixelSize: rect1.height*0.45

                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: null // Disable dragging
                    }
                    
                }
                Rectangle{
                    id:rect2
                    height: parent.height
                    width: tableviewcomp.width*0.25
                    anchors.left: rect1.right
                    color: qgcPal.buttonHighlight
                    border.color: qgcPal.toolbarBackground

                    Text {
                        id: firmwaretype
                        text: qsTr("Firmware Type")
                        color: qgcPal.text
                        anchors.centerIn: parent
                        font.pixelSize: rect1.height*0.45

                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: null // Disable dragging
                    }
                    
                }
                Rectangle{
                    id:rect3
                    height: parent.height
                    width: tableviewcomp.width*0.25
                    anchors.left: rect2.right
                    color: qgcPal.buttonHighlight
                    border.color: qgcPal.toolbarBackground

                    Text {
                        id: vehicletype
                        text: qsTr("Vehicle Type")
                        color: qgcPal.text
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: null // Disable dragging
                    }
                }

                Rectangle{
                    height: parent.height
                    width: tableviewcomp.width*0.25
                    anchors.left: rect3.right
                    color: qgcPal.buttonHighlight
                    border.color: qgcPal.toolbarBackground

                    Text {
                        id: selected
                        text: qsTr("Selected")
                        color: qgcPal.text
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        drag.target: null // Disable dragging
                    }
                }




            }

            rowDelegate: Rectangle {
                id:rowdelegateid
                height: tableviewcomp.height/11//64//parent.height*4 // Set the height of each row
                color: "transparent"



                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    hoverEnabled: true

                    onHoveredChanged: {
                        if(containsMouse){
                            rowdelegateid.color = model ?qgcPal.windowShadeLight : "transparent"

                        }
                        else{
                            rowdelegateid.color = "transparent"
                        }
                    }

                    onPressed: {
                        rowdelegateid.color = model ?qgcPal.windowShadeLight : "transparent"
                    }

                    onReleased: {
                        rowdelegateid.color = "transparent"
                    }


                    onClicked: {
                        for (var i = 0; i < droneModel.count; i++) {
                            droneModel.setProperty(i, "selected", "/custom/img/DroneUnselectIcon.png");
                        }
                        droneModel.setProperty(model.row, "selected", "/custom/img/DroneSelectIcon.png");

                        var vehicle = QGroundControl.multiVehicleManager.getVehicleById(model.vehid);
                        QGroundControl.multiVehicleManager.activeVehicle = vehicle;
                        droneSelected();
                        if(dataTimer.running){
                            dataTimer.stop()
                        }

                        dataTimer.start();
                    }
                }


            }

        }

        Rectangle{
            id:popuprectid
            height: parent.height*0.2
            width: parent.width*0.8
            color: "transparent"
            anchors.centerIn: parent
            Text {
                id: txtid
                text: qsTr("No Vehicle Connected ")
                color: qgcPal.buttonHighlight
                font.pixelSize: parent.width*0.02
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                id: dashboardbtn
                height: parent.height*0.4
                width: parent.width*0.13
                color: qgcPal.buttonHighlight
                border.color:qgcPal.windowShadeDark
                anchors.top: txtid.bottom
                anchors.topMargin: parent.height*0.2
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: txtid1
                    text: qsTr("Dashboard")// This is available in all editors.
                    anchors.centerIn: parent
                    color: qgcPal.text
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onHoveredChanged: {
                        if(containsMouse){
                            dashboardbtn.opacity = 0.7
                        }
                        else{
                            dashboardbtn.opacity = 1
                        }
                    }


                    onPressed: {
                        dashboardbtn.opacity = 0.5
                    }

                    onReleased: {
                        dashboardbtn.opacity = 1
                    }

                    onClicked: {
                        droneSelected()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        popuprectid.visible = true;
    }


}

