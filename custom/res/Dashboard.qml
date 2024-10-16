import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 1.4
import QtCharts 2.15

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0

Rectangle {
    id: dashrect
    color:qgcPal.windowShade
    radius: 10
    property var userid: ""
    property var userrole: ""
    property var regDate: ""

    property var _activevechile: QGroundControl.multiVehicleManager.activeVehicle
    property var _unitsSettings: QGroundControl.settingsManager.unitsSettings
    property var sensorname: _activevechile.sysStatusSensorInfo.sensorNames
    property var sensorvalue: _activevechile.sysStatusSensorInfo.sensorStatus
    property var _planMasterController: _activevechile.planMasterControllerPlanView

    //property alias bckbuttonmousearea: bckbuttonmousearea

    Component.onCompleted: {
        populateData()
    }

    Connections{
        target: roleModel

        function onCurrentSelectedRoleChanged(id, role, reg){
            userid = id
            var ind = rolepermModel.getModelIndex(role)
            userrole = rolepermModel.getRoleParameter(ind, "rolename")
            regDate = opCls.getDateTime(reg)
        }
    }

    function populateData(){
        parametermodel.clear()
        parametermodel.append({ paramname: "Vehicle ID",value: (_activevechile != null) ? _activevechile.id.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Vehicle Type",value: (_activevechile != null) ? _activevechile.vehicleTypeName() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Firmware Type",value:(_activevechile != null) ?  _activevechile.firmwareTypeString.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Altitude",value: (_activevechile != null) ? _activevechile.altitudeAboveTerr.value+" "+QGroundControl.unitsConversion.appSettingsVerticalDistanceUnitsString : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Height above the mean sea level (ASML)",value: (_activevechile != null) ? _activevechile.altitudeAMSL.value.toFixed(4)+" "+QGroundControl.unitsConversion.appSettingsVerticalDistanceUnitsString : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Latitude",value:(_activevechile != null) ? _activevechile.latitude.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Longitude",value: (_activevechile != null) ? _activevechile.longitude.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Speed",value:( _activevechile != null) ? _activevechile.groundSpeed.value.toFixed(4)+" "+QGroundControl.unitsConversion.appSettingsSpeedUnitsString : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Battery/Fuel Percentage",value: (_activevechile != null) ? _activevechile.batteries.get(0).percentRemaining.value + " "+"%" : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Heading of the UAV", value: (_activevechile != null) ? _activevechile.heading.value : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Flight Mode", value: (_activevechile != null) ? _activevechile.flightMode.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Distance from the GCS", value: (_activevechile != null) ? _activevechile.distanceToGCS.value+" "+QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Distance from the Target", value: "NA", underline: "/custom/img/UnderLineIcon.svg" })
        //parametermodel.append({ paramname: "Mission Time", value: _planMasterController.missionController.missionTime, underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Magnetometer Sensor", value: (_activevechile != null) ? sensorvalue[0] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "AHRS Sensor", value: (_activevechile != null) ? sensorvalue[1] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Gyro Sensor", value: (_activevechile != null) ? sensorvalue[2] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Accelerometer Sensor", value: (_activevechile != null) ? sensorvalue[3] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Absolute Pressure Sensor", value: (_activevechile != null) ? sensorvalue[4] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Angular Rate Control Sensor", value: (_activevechile != null) ? sensorvalue[5] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Attitude Stabilization Sensor", value: (_activevechile != null) ? sensorvalue[6] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Yaw Position Sensor", value: (_activevechile != null) ? sensorvalue[7] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Motor Output Sensor", value: (_activevechile != null) ? sensorvalue[8] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Terrain Sensor", value: (_activevechile != null) ? sensorvalue[9] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Battery Sensor", value: (_activevechile != null) ? sensorvalue[10] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Propulsion Sensor", value: (_activevechile != null) ? sensorvalue[11] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Z/altitude Control Sensor", value: (_activevechile != null) ? sensorvalue[12] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "X/Y Position Control Sensor",value: (_activevechile != null) ? sensorvalue[13] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "GeoFence Sensor",value: (_activevechile != null) ? sensorvalue[14] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Logging Sensor",value: (_activevechile != null) ? sensorvalue[15] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Pre-Arm Check Sensor",value: (_activevechile != null) ? sensorvalue[16] : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Payload Status (Camera)",value: "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Communication Link Status (Signal Strength)", value: (_activevechile != null) ? _activevechile.rcRSSI.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Wind Speed", value: (_activevechile != null) ? _activevechile.wind.speed.value+" "+QGroundControl.unitsConversion.appSettingsSpeedUnitsString: "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Wind Direction", value: (_activevechile != null) ? _activevechile.wind.direction.value+" deg" : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Temperature", value: (_activevechile != null) ? _activevechile.temperature.temperature1.value+" C" : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Message Count", value: (_activevechile != null) ? _activevechile.messageCount.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
        parametermodel.append({ paramname: "Firmware Version", value: (_activevechile != null) ? _activevechile.firmwareCustomMajorVersion.toString()+"."+_activevechile.firmwareCustomMinorVersion.toString()+"."+_activevechile.firmwareCustomPatchVersion.toString() : "NA", underline: "/custom/img/UnderLineIcon.svg" })
    }

    QGCPalette { id: qgcPal }

    Rectangle{
        id: toolbar
        color: qgcPal.toolbarBackground
        width: parent.width*0.98
        height: parent.height*0.07
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.02
        border.color: qgcPal.buttonHighlight
        border.width: 2
        radius: 6

        Text{
            id: toolbartxt
            text:"Welcome to Ground Control Station, "+userid+"!"
            font.pixelSize: parent.height*0.4
            color: qgcPal.text
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.4
        }
    }

    Rectangle{
        id: userprofile
        color: qgcPal.toolbarBackground
        width: parent.width*0.3
        height: parent.height*0.45
        anchors.top: toolbar.bottom
        anchors.topMargin: parent.height*0.02
        anchors.left: parent.left
        anchors.leftMargin: parent.width*0.01
        border.color: qgcPal.buttonHighlight
        border.width: 2
        radius: 6

        Text{
            id: userprofilehead
            text: "User Profile"
            font.pixelSize: parent.height*0.07
            color: qgcPal.text
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.05
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.05
            font.bold: true
            wrapMode: Text.NoWrap
        }

        Image{
            id: userprofileimg
            width: parent.height*0.3
            height: parent.height*0.3
            source: "/custom/img/userprofile.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.14

            ColorOverlay{
                anchors.fill: parent
                source: userprofileimg
                color:qgcPal.text
            }
        }

        Rectangle{
            width: parent.width
            height: parent.height*0.5
            color: "transparent"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.04

            Text{
                id: useridtxt
                text:"User ID: "+userid
                font.pixelSize: parent.height*0.12
                color: qgcPal.text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: roletxt.top
                anchors.bottomMargin: parent.height*0.08
                wrapMode: Text.NoWrap
            }

            Text{
                id: roletxt
                text:"Role: "+userrole
                font.pixelSize: parent.height*0.12
                color: qgcPal.text
                anchors.centerIn: parent
                wrapMode: Text.NoWrap
            }

            Text{
                id: regdate
                text:"Reg. Date: "+regDate
                font.pixelSize: parent.height*0.12
                color: qgcPal.text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: roletxt.bottom
                anchors.topMargin: parent.height*0.08
                wrapMode: Text.NoWrap
            }

        }
    }

    Rectangle{
        id: params1
        color: qgcPal.toolbarBackground
        width: parent.width*0.28
        height: parent.height*0.215
        anchors.top: toolbar.bottom
        anchors.topMargin: parent.height*0.02
        anchors.left: userprofile.right
        anchors.leftMargin: parent.width*0.01
        border.color: qgcPal.buttonHighlight
        border.width: 2
        radius: 6

        Text{
            id: params1head
            text: "Mission Data"
            font.pixelSize: parent.height*0.14
            color: qgcPal.text
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.1
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.1
            font.bold: true
            wrapMode: Text.NoWrap
        }

        Rectangle{
            id: missionDist
            color: qgcPal.windowShadeDark
            width: parent.width*0.45
            height: parent.height*0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.1
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: parent.height*0.04
            border.color: qgcPal.buttonHighlight
            border.width: 1
            radius: 5

            Text{
                id: missiondist
                text: "Mission Distance"
                font.pixelSize: parent.height*0.165
                color: qgcPal.text
                anchors.top: parent.top
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
            }

            Text{
                id: missiondistval
                text: "4356 ft"//_planMasterController.missionController.missionDistance + " "+_unitsSettings.appSettingsHorizontalDistanceUnitsString
                font.pixelSize: parent.height*0.26
                color: qgcPal.buttonHighlight
                anchors.top: missiondist.bottom
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
                font.bold: true
            }
        }

        Rectangle{
            id: missionTime
            color: qgcPal.windowShadeDark
            width: parent.width*0.45
            height: parent.height*0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.1
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: parent.height*0.04
            border.color: qgcPal.buttonHighlight
            border.width:1
            radius: 5

            Text{
                id: missiontime
                text: "Mission Time"
                font.pixelSize: parent.height*0.165
                color: qgcPal.text
                anchors.top: parent.top
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
            }

            Text{
                id: missiontimeval
                text: "00:00:00"//_planMasterController.missionController.missionTime
                font.pixelSize: parent.height*0.26
                color: qgcPal.buttonHighlight
                anchors.top: missiontime.bottom
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
                font.bold: true
            }
        }
    }

    Rectangle{
        id: params2
        color: qgcPal.toolbarBackground
        width: parent.width*0.28
        height: parent.height*0.215
        anchors.top: params1.bottom
        anchors.topMargin: parent.height*0.02
        anchors.left: userprofile.right
        anchors.leftMargin: parent.width*0.01
        border.color: qgcPal.buttonHighlight
        border.width: 2
        radius: 6

        Text{
            id: params2head
            text: "Flight Data"
            font.pixelSize: parent.height*0.14
            color: qgcPal.text
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.1
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.1
            font.bold: true
            wrapMode: Text.NoWrap
        }

        Rectangle{
            id: flightDist
            color: qgcPal.windowShadeDark
            width: parent.width*0.45
            height: parent.height*0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.1
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: parent.height*0.04
            border.color: qgcPal.buttonHighlight
            border.width: 1
            radius: 5

            Text{
                id: flightdist
                text: "Flight Distance"
                font.pixelSize: parent.height*0.165
                color: qgcPal.text
                anchors.top: parent.top
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
            }

            Text{
                id: flightdistval
                text:"6523 ft"
                font.pixelSize: parent.height*0.26
                color: qgcPal.buttonHighlight
                anchors.top: flightdist.bottom
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
                font.bold: true
            }
        }

        Rectangle{
            id: vehSpeed
            color: qgcPal.windowShadeDark
            width: parent.width*0.45
            height: parent.height*0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.1
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: parent.height*0.04
            border.color: qgcPal.buttonHighlight
            border.width:1
            radius: 5

            Text{
                id: vehspeed
                text: "Speed"
                font.pixelSize: parent.height*0.165
                color: qgcPal.text
                anchors.top: parent.top
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
            }

            Text{
                id: vehspeedval
                text: _activevechile.groundSpeed.value.toFixed(4) + " "+QGroundControl.unitsConversion.appSettingsSpeedUnitsString
                font.pixelSize: parent.height*0.28
                color: qgcPal.buttonHighlight
                anchors.top: vehspeed.bottom
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
                font.bold: true
            }
        }

    }

    Rectangle{
        id: paramslist
        color: qgcPal.toolbarBackground
        width: parent.width*0.38
        height: parent.height*0.87
        anchors.top: toolbar.bottom
        anchors.topMargin: parent.height*0.02
        anchors.left: params1.right
        anchors.leftMargin: parent.width*0.01
        border.color: qgcPal.buttonHighlight
        border.width: 2
        radius: 6

        Text{
            id: paramslisthead
            text: "Parameters"
            font.pixelSize: parent.height*0.037
            color: qgcPal.text
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.03
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.03
            font.bold: true
            wrapMode: Text.NoWrap
        }

        ListModel {
            id: parametermodel
        }

        TableView {
            id: tableviewcomp
            height: parent.height*.88
            width: parent.width*.92
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: paramslisthead.bottom
            anchors.topMargin: parent.height*0.02
            backgroundVisible: false
            frameVisible: false
            verticalScrollBarPolicy: ScrollBar.AlwaysOff

            model: parametermodel

            TableViewColumn {
                role: "paramname"
                title: "Parameter Name"
                width: parent.width*.23

                delegate: Item {
                    Rectangle {
                        width: parent.width
                        height: parent.height*.64
                        color: "transparent"
                        radius: parent.height*.1

                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.1
                            text: model ? qsTr(styleData.row+1 + ". " + model.paramname) : ""
                            font {
                                pixelSize: parent.height*.55
                                bold: false
                            }
                            color: qgcPal.text
                            clip: true
                            anchors.fill: parent
                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap
                        }
                    }
                }
            }

            TableViewColumn {
                role: "value"
                title: "Value"
                width: parent.width*.1

                delegate: Item {
                    Rectangle {
                        width: parent.width
                        height: parent.height*.64
                        color: "transparent"
                        radius: parent.height*.1

                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: parent.height*.2
                            text: (model) ? qsTr(model.value) : "NA"
                            font {
                                pixelSize: parent.height*.55 // Set the font size
                                bold: false
                            }
                            color: qgcPal.text
                            clip: true
                            anchors.fill: parent
                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap
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
                        height: parent.height*.03
                        x: parent.width*(-1.5)
                        y: parent.height*(-.15)
                        color: "transparent"
                        radius: parent.height*.1

                        Image {
                            source: model ? model.underline : ""
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
                height: 0
            }

            rowDelegate: Item {
                height: tableviewcomp.height/12//64//parent.height*4 // Set the height of each row
            }
        }

    }

    Rectangle{
        id: activevehicles
        color: qgcPal.toolbarBackground
        width: parent.width*0.3
        height: parent.height*0.4
        anchors.top: userprofile.bottom
        anchors.topMargin: parent.height*0.02
        anchors.left: parent.left
        anchors.leftMargin: parent.width*0.01
        border.color: qgcPal.buttonHighlight
        border.width: 2
        radius: 6

        Text{
            id: activevehicleshead
            text: "Vehicle Status"
            font.pixelSize: parent.height*0.072
            color: qgcPal.text
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.06
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.06
            font.bold: true
            wrapMode: Text.NoWrap
        }


        ChartView {
            id: chart
            //title: "Active/Inactive Drones"
            backgroundColor: "transparent"
            //titleColor: qgcPal.text
            width: parent.width*1.2
            height: parent.height*1.2
            anchors.centerIn: parent
            legend.alignment: Qt.AlignBottom
            legend.labelColor: qgcPal.text
            legend.font.pixelSize: parent.width*0.04
            legend.size: parent.width*0.07
            antialiasing: true

            PieSeries {
                id: pieSeries
                PieSlice {
                    labelPosition: PieSlice.LabelInsideHorizontal
                    label: "Active"
                    labelColor: qgcPal.text
                    labelFont.pixelSize: parent.width*0.05
                    value: 1
                    color: qgcPal.buttonHighlight

                }
                PieSlice {
                    labelPosition: PieSlice.LabelInsideHorizontal
                    label: "Inactive"
                    labelColor: qgcPal.text
                    labelFont.pixelSize: parent.width*0.05
                    value: 0
                }

                onClicked: {

                }
            }
        }
    }

    Rectangle{
        id: histdata
        color: qgcPal.toolbarBackground
        width: parent.width*0.28
        height: parent.height*0.4
        anchors.top: params2.bottom
        anchors.topMargin: parent.height*0.02
        anchors.left: activevehicles.right
        anchors.leftMargin: parent.width*0.01
        border.color: qgcPal.buttonHighlight
        border.width: 2
        radius: 6

        Text{
            id: histdatahead
            text: "History Records"
            font.pixelSize: parent.height*0.072
            color: qgcPal.text
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.06
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.06
            font.bold: true
            wrapMode: Text.NoWrap
        }

        Rectangle{
            id: historydata
            color: qgcPal.windowShadeDark
            width: parent.width*0.6
            height: parent.height*0.36
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: histdatahead.bottom
            anchors.topMargin: parent.height*0.12
            border.color: qgcPal.buttonHighlight
            border.width:1
            radius: 5

            Text{
                id: histdatatitle
                text: "Total History Data"
                font.pixelSize: parent.height*0.18
                color: qgcPal.text
                anchors.top: parent.top
                anchors.topMargin: parent.height*0.12
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
            }

            Text{
                id: histdatacount
                text: "15"
                font.pixelSize: parent.height*0.27
                color: qgcPal.buttonHighlight
                anchors.top: histdatatitle.bottom
                anchors.topMargin: parent.height*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.NoWrap
                font.bold: true
            }
        }


        Rectangle{
            id: generatereport
            width: parent.width
            height: parent.height*0.13
            color: "transparent"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.05

            Image {
                id: generateicn
                source: "/custom/img/GenerateIcon.png"
                height: parent.height*.8
                width: parent.height*.8
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width*0.27

                ColorOverlay{
                    anchors.fill: parent
                    source: parent
                    color:qgcPal.buttonHighlight
                }
            }
            Text{
                id: generatetxt
                text: "Generate Reports"
                font.pixelSize: parent.height*0.5
                color: qgcPal.text
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: generateicn.right
                anchors.leftMargin: parent.height*0.15
                wrapMode: Text.NoWrap
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    if(containsMouse){
                        generatereport.opacity = 0.5
                    }
                    else{
                        generatereport.opacity = 1
                    }
                }

                onPressed: {
                    generatereport.opacity = 0.5
                }

                onReleased: {
                    generatereport.opacity = 1
                }
            }

        }

    }
}
