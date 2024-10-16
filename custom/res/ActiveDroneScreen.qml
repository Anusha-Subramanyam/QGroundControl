import QtQuick          2.12
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

    Connections {
        target: QGroundControl.multiVehicleManager.vehicles
        onCountChanged:{
            console.log(QGroundControl.multiVehicleManager.vehicles.count)
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

            droneModel.append({vehid: vehicle.id , firmtype: vehicle.firmwareTypeString ,vehtype: vehicle.vehicleTypeString  })
        }
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
            //ListElement { vehid: "001"; firmtype: "PX4"; vehtype: "Quadcopter"}
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


                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.1
                            text: model ? model.vehid : ""
                            font {
                                pixelSize: parent.height*.55
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

                        property var    _vehicle:   object

                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.1
                            text: model ? model.firmtype : ""
                            font {
                                pixelSize: parent.height*.55
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


                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.1
                            text: model ? model.vehtype : ""
                            font {
                                pixelSize: parent.height*.55
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

                        property var    _vehicle:   object

                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.2
                            text: model ? "true" : ""
                            font {
                                pixelSize: parent.height*.55 // Set the font size
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
                role: "underline"
                title: "underline"
                width: tableviewcomp.width

                delegate: Item {
                    Rectangle {
                        width: parent.width*5
                        height: parent.height*.04
                        x: parent.width*(-1.5)
                        y: parent.height*(-.15)
                        color: "transparent"
                        radius: parent.height*.1

                        Image {
                            source: "/custom/img/UnderLineIcon.svg"
                            height: parent.height*.85
                            width: parent.width
                            anchors.centerIn: parent

                            ColorOverlay{
                                anchors.fill: parent
                                source: parent
                                color:qgcPal.buttonHighlight
                            }
                        }
                    }
                }
            }


            headerDelegate: Rectangle {
                height: tableviewcomp.height*0.08
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
                }




            }

            rowDelegate: Item {
                height: tableviewcomp.height/7//64//parent.height*4 // Set the height of each row

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var vechile = QGroundControl.multiVehicleManager.getVehicleById(model.vehid)
                        QGroundControl.multiVehicleManager.activeVehicle = vechile
                        droneSelected()
                    }
                }
            }
        }

    }


}

