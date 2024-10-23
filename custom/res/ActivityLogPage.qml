import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQuick.Dialogs              1.3
import QtQuick.Layouts              1.11
import QtQuick.Controls             1.4
import QtQuick.Controls 2.15

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0
import QtGraphicalEffects 1.15

AnalyzePage {
    id:                 activitylogpage
    pageComponent:      pageComponent
    pageDescription:    qsTr("User Activity Logs denote the activities or events performed by a specific user during his session.")

    property real _margin:          ScreenTools.defaultFontPixelWidth
    property real _butttonWidth:    ScreenTools.defaultFontPixelWidth * 10

    property int numPages: 14
    property int middlecnt: numPages/2
    property int currentPage: 0
    property int numberOfPage: 0
    property int count: 1


    QGCPalette { id: palette; colorGroupEnabled: enabled }


    Component {
        id: pageComponent


        Rectangle{
            id:clmlayid
            width:  availableWidth
            height: availableHeight
            color: 'transparent'

            Component.onCompleted: {

                console.log(dstDb.numberofRowsDB());
                // numberOfPage = Math.ceil(dstDb.numberofRowsDB()/10);
                numberOfPage = Math.ceil(74/10);
                // console.log(numberOfPage);
                btn1.enabled = false
                btn1.opacity = 0.5
                if(numberOfPage==1){
                    btn1.enabled = false
                    btn2.enabled = false
                    btn1.opacity = 0.5
                    btn2.opacity = 0.5
                }
            }

            TableView {
                id: tableView
                Layout.fillWidth:   true
                Layout.fillHeight: true
                // height: parent.height

                height:parent.height*0.92
                width : parent.width
                // model: myModel
                // anchors.fill: parent
                // columnSpacing: 1
                // rowSpacing: 1
                // clip: true

                TableViewColumn {
                    role: "timestamp"
                    title: "Timestamp"
                    width: 200
                    horizontalAlignment: Text.AlignHCenter
                }
                TableViewColumn {
                    role: "userId"
                    title: "UserId"
                    width: 200
                    horizontalAlignment: Text.AlignHCenter
                }
                TableViewColumn {
                    role: "activity"
                    title: "Activity"
                    width: 200
                    horizontalAlignment: Text.AlignHCenter
                }
                TableViewColumn {
                    role: "description"
                    title: "Description"
                    width: 300
                    horizontalAlignment: Text.AlignHCenter
                }
            }


            Rectangle{
                id:mainrect
                height: parent.height*0.08
                width  : parent.width
                color: "transparent"
                anchors.top: tableView.bottom

                RowLayout{

                    anchors.horizontalCenter: mainrect.horizontalCenter
                    anchors.verticalCenter :  mainrect.verticalCenter
                    Rectangle{
                        id:btn1
                        height: mainrect.height*0.8
                        width  : mainrect.height*0.8
                        // enabled: false
                        // opacity: 0.5
                        color: "transparent"


                        Image{
                            id: dronelistid
                            source: "/custom/img/Arrow.png"
                            anchors.fill: parent
                            anchors.centerIn: parent
                            ColorOverlay{
                                id:coloroverid
                                anchors.fill: parent
                                source: dronelistid
                                color:qgcPal.text
                            }
                            mirror: true
                        }
                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if(count>1){
                                    --count
                                    if(count==1){
                                        btn1.enabled = false
                                        btn1.opacity = 0.5
                                    }

                                    btn2.enabled = true
                                    btn2.opacity = 1
                                }else{
                                    btn1.enabled = false
                                    btn1.opacity = 0.5
                                }
                            }
                        }
                    }
                    Rectangle{
                        id:text
                        height: mainrect.height*0.8
                        width  : mainrect.width*0.05
                        color: "transparent"
                        // border.width: 5;


                        Text {
                            id: text1
                            text: qsTr(count + " " + "/"+" " +numberOfPage )
                            anchors.centerIn: parent
                            font.pixelSize: text.width*0.23
                            font.bold: true
                            color: qgcPal.text
                        }

                    }
                    Rectangle{
                        id:btn2
                        height: mainrect.height*0.8
                        width  : mainrect.height*0.8
                        color: "transparent"
                        // border.width: 5;


                        // Text {
                        //     id: name2
                        //     text: qsTr("Next >>")
                        //     anchors.centerIn: parent
                        //     font.pixelSize: 30
                        //     color: "white"
                        // }

                        Image{
                            id: dronelistid1
                            source: "/custom/img/Arrow.png"
                            anchors.fill: parent
                            anchors.centerIn: parent
                            ColorOverlay{
                                id:coloroverid1
                                anchors.fill: parent
                                source: dronelistid1
                                color:qgcPal.text
                            }


                        }
                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if(count<numberOfPage){
                                    ++count
                                    if(count==numberOfPage){
                                        btn2.enabled = false
                                        btn2.opacity = 0.5
                                    }

                                    btn1.enabled = true
                                    btn1.opacity = 1
                                }else{
                                    btn2.enabled = false
                                    btn2.opacity = 0.5
                                }
                            }
                        }
                    }
                }
            }



        }


    }

}
