import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Controls 1.3
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs  1.2
import QtQuick.Layouts      1.2
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.15

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0

Item {

    signal closepopup()
    signal openpopup()
    property var rowSelected: 0
    property var username: ""
    // property alias userrolemodel: userregister
    property alias backbtnmousearea: backbtnmousearea
    property var _activevechile: QGroundControl.multiVehicleManager.activeVehicle

    function loadMissionHistory(){
        console.log("In LoadMission Data Function")
        var missionData = dstDb.readMissionHistory(_activevechile.id.toString(), false);
        historyModel.clear()
        for(var i=0;i<missionData.length;i++){
            console.log("Missions data: ",i," ",missionData[i])
            historyModel.append({missionid: missionData[i][0], missiondate: missionData[i][1], missiontime: missionData[i][2]})
        }
    }

    Rectangle{
        id: mainRect
        anchors.fill: parent
        color:qgcPal.windowShade
        // radius: 10

        Rectangle{
            id: usertoolbar
            color: qgcPal.toolbarBackground
            width: parent.width*0.98
            height: parent.height*0.07
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.02
            border.color: qgcPal.buttonHighlight
            border.width: 2
            // radius: 6

            // Rectangle{
            //     height: parent.height*0.7
            //     width: parent.width*0.1
            //     color: qgcPal.buttonHighlight
            //     anchors.left: parent.left
            //     anchors.leftMargin: parent.height*0.3
            //     anchors.verticalCenter: parent.verticalCenter
            //     radius: 10

            //     Text{
            //         id: usertoolbartxt
            //         text:"logo"
            //         font.pixelSize: parent.height*0.4
            //         color: qgcPal.text
            //         anchors.centerIn: parent
            //         anchors.left: parent.left
            //         anchors.leftMargin: parent.height*0.4
            //     }
            // }

            Rectangle{
                height: parent.height*0.7
                width: parent.width*0.07
                color: qgcPal.buttonHighlight
                anchors.right:  parent.right
                anchors.rightMargin: parent.height*0.3
                anchors.verticalCenter: parent.verticalCenter
                radius: 10

                Text{
                    id: usertoolbartxt2
                    text:"Back"
                    font.pixelSize: parent.height*0.4
                    color: qgcPal.text
                    anchors.centerIn: parent
                    anchors.left: parent.left
                    anchors.leftMargin: parent.height*0.4
                }

                MouseArea{
                    id:backbtnmousearea
                    anchors.fill: parent
                }
            }
        }

        Rectangle{
            id: usercontent
            color: qgcPal.toolbarBackground
            width: parent.width*0.98
            height: parent.height*0.867
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: usertoolbar.bottom
            anchors.topMargin: parent.height*0.02
            border.color: qgcPal.buttonHighlight
            border.width: 2
            // radius: 6

            Rectangle{
                id: heading
                width: parent.width*0.3
                height: parent.height*0.074
                color: "transparent"
                border.color: "transparent"
                border.width: 1
                anchors.top:parent.top
                anchors.topMargin: parent.height*0.02
                radius: 6
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    id: userprofileimg
                    width: parent.width
                    height: parent.height*0.08
                    source: "/custom/img/UnderLineIcon.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    // anchors.topMargin: parent.height*0.14

                    ColorOverlay{
                        anchors.fill: parent
                        source: userprofileimg
                        color:qgcPal.text
                    }
                }

                Text {
                    id:headtxtid
                    text: qsTr("Mission Histroy")
                    color: qgcPal.text
                    font.pixelSize: parent.width*.07
                    anchors.centerIn: parent
                    anchors.top: userprofileimg.bottom
                    anchors.bottom: userprofileimg2.top
                    anchors.topMargin: parent.height*0.14
                }

                Image{
                    id: userprofileimg2
                    width: parent.width
                    height: parent.height*0.08
                    source: "/custom/img/UnderLineIcon.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: headtxtid.bottom
                    anchors.topMargin: parent.height*0.14

                    ColorOverlay{
                        anchors.fill: parent
                        source: userprofileimg
                        color:qgcPal.text
                    }
                }


            }

            Rectangle{
                id: vehData
                width: parent.width*0.23
                height: parent.height*0.08
                color: "transparent"
                radius: 6
                border.color: "transparent"
                border.width: 1
                anchors.top:heading.bottom
                anchors.topMargin: parent.height*0.035
                anchors.left: parent.left
                anchors.leftMargin: parent.width*0.02

                Text {
                    id: vecid
                    text: qsTr("Vehicle ID : " ,_activevechile.id )
                    anchors.top: parent.top
                    anchors.left: parent.left
                    font.pixelSize: parent.width*0.05
                    color: qgcPal.text

                }
                Text {
                    id: vectype
                    text: qsTr("Vehicle Type : " ,_activevechile.vehicleTypeString)
                    anchors.top: vecid.bottom
                    anchors.left: parent.left
                    font.pixelSize: parent.width*0.05
                    color: qgcPal.text
                    anchors.topMargin: parent.width*0.03
                }



            }

            Rectangle{
                id: rect23
                width: parent.width*0.23
                height: parent.height*0.08
                color: "transparent"
                radius: 6
                border.color: "transparent"
                border.width: 1
                anchors.top:heading.bottom
                anchors.topMargin: parent.height*0.035
                anchors.left: parent.left
                anchors.leftMargin: 1600

                Text {
                    id: firmwaretypeid
                    text: qsTr("Firmware Type : ", _activevechile.firmwareTypeString)
                    anchors.top: parent.top
                    anchors.left: parent.left
                    font.pixelSize: parent.width*0.05
                    color: qgcPal.text

                }
                Text {
                    id: noofmission
                    text: qsTr("No. of Mission : ",tableviewcomp.model.rowCount() )
                    anchors.top: firmwaretypeid.bottom
                    anchors.left: parent.left
                    font.pixelSize: parent.width*0.05
                    color: qgcPal.text
                    anchors.topMargin: parent.width*0.03

                }
            }

            ListModel {
                id: historyModel
                //ListElement{missionid: "Hii"; missiondate: "Hello"; missiontime: "Hyyy"}
            }

            Rectangle{
                id: tableRect
                width: parent.width*0.97
                height: parent.height*0.7
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: vehData.bottom
                anchors.topMargin: parent.height*0.05
                color:"transparent"

                TableView {
                    id: tableviewcomp
                    anchors.fill: parent
                    backgroundVisible: false
                    frameVisible: true
                    verticalScrollBarPolicy: ScrollBar.AsNeeded  // You can use ScrollBar.AlwaysOff or ScrollBar.AsNeeded as well
                    model: historyModel
                    horizontalScrollBarPolicy: ScrollBar.AlwaysOff

                    TableViewColumn {
                        role: "slno"
                        title: "slno"
                        width: tableviewcomp.width*.1

                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: model ? qsTr((styleData.row+1).toString()) : ""  // Display the setup or any other data
                                    font.pixelSize: parent.height*.53
                                    color: qgcPal.text  // Set the text color
                                    clip: true
                                    elide: Text.ElideRight
                                    wrapMode: Text.WrapAnywhere
                                }
                            }
                        }
                    }

                    TableViewColumn {
                        role: "missionid"
                        title: "missionid"
                        width: tableviewcomp.width*0.220

                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.height*0.1
                                    text: model ? model.missionid : ""
                                    font.pixelSize: parent.height*.53
                                    color: qgcPal.text  // Set the text color
                                    clip: true
                                    elide: Text.ElideRight
                                    wrapMode: Text.WrapAnywhere
                                }
                            }
                        }
                    }

                    TableViewColumn {
                        role: "missiondate"
                        title: "missiondate"
                        width: tableviewcomp.width*0.25

                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.height*0.1
                                    text: model ? model.missiondate : ""
                                    font.pixelSize: parent.height*.53
                                    color: qgcPal.text  // Set the text color
                                    clip: true
                                    elide: Text.ElideRight
                                    wrapMode: Text.WrapAnywhere
                                }
                            }
                        }
                    }

                    TableViewColumn {
                        role: "missiontime"
                        title: "missiontime"
                        width: tableviewcomp.width*0.230


                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.height*0.1
                                    text: model ? model.missiontime : ""
                                    font.pixelSize: parent.height*.53
                                    color: qgcPal.text  // Set the text color
                                    clip: true
                                    elide: Text.ElideRight
                                    wrapMode: Text.WrapAnywhere
                                }
                            }
                        }
                    }

                    TableViewColumn {
                        role: "generaterep"
                        title: "generaterep"
                        width: tableviewcomp.width*0.2


                        delegate: Item {
                            Rectangle {
                                id:genreport
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Image {
                                    source:  "/custom/img/download.png"
                                    height: parent.height*.9
                                    width: parent.height*.9
                                    anchors.centerIn: parent

                                }
                                MouseArea{
                                    id: genreportmousearea
                                    anchors.fill: parent

                                    onPressed: {
                                        genreport.opacity = 0.5
                                    }

                                    onReleased: {
                                        genreport.opacity = 1

                                    }

                                    onClicked: {

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
                    //             height: parent.height*.02
                    //             x: parent.width*(-1.6)
                    //             y: parent.height*(-.17)
                    //             color: "transparent"
                    //             radius: parent.height*.1

                    //             Image {
                    //                 source: "/custom/img/UnderLineIcon.svg"
                    //                 height: parent.height*.85
                    //                 width: parent.width
                    //                 anchors.centerIn: parent
                    //             }
                    //         }
                    //     }
                    // }


                    headerDelegate: Rectangle {
                        height: tableviewcomp.height*0.08
                        width: tableviewcomp.width
                        color: "transparent"

                        Rectangle{
                            id:rect1
                            height: parent.height
                            width: tableviewcomp.width*0.1
                            anchors.left: parent.left
                            color: qgcPal.buttonHighlight
                            border.color:qgcPal.toolbarBackground
                            // anchors.leftMargin:tableviewcomp.width*0.05

                            Text {
                                id: slnotxt
                                text: qsTr("Serial No.")
                                color: qgcPal.text
                                anchors.centerIn: parent

                            }

                            MouseArea {
                                anchors.fill: parent
                                drag.target: null // Disable dragging
                            }
                        }
                        Rectangle{
                            id:rect2
                            height: parent.height
                            width: tableviewcomp.width*0.220
                            anchors.left: rect1.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: missionid
                                text: qsTr("Mission ID")
                                color: qgcPal.text
                                anchors.centerIn: parent

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
                                id: missiondate
                                text: qsTr("Date")
                                color: qgcPal.text
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                drag.target: null // Disable dragging
                            }
                        }

                        Rectangle{
                            id: rect4
                            height: parent.height
                            width: tableviewcomp.width*0.230
                            anchors.left: rect3.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: missiontime
                                text: qsTr("Mission Time")
                                color: qgcPal.text
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                drag.target: null // Disable dragging
                            }
                        }

                        Rectangle{
                            id: rect5
                            height: parent.height
                            width: tableviewcomp.width*0.2
                            anchors.left: rect4.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: generatereport
                                text: qsTr("Generate report")
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
                        id: rowitem
                        height: tableviewcomp.height/16//64//parent.height*4 // Set the height of each row
                        width: tableviewcomp.width
                        color: "transparent"
                        MouseArea{
                            anchors.fill:parent
                            hoverEnabled: true

                            onHoveredChanged: {
                                if(model){
                                    if(containsMouse){
                                        rowitem.color = qgcPal.windowShadeLight
                                    }
                                    else{
                                        rowitem.color = "transparent"
                                    }
                                }


                            }
                        }
                    }
                }


            }

        }



    }



}








