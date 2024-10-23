import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Controls 1.3
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs  1.2
import QtQuick.Layouts      1.2
import QtQuick.Controls 1.4

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
    property alias userrolemodel: userregister
    Rectangle{
        id: mainRect
        anchors.fill: parent
        color:qgcPal.windowShade
        radius: 10

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
            radius: 6

            Text{
                id: usertoolbartxt
                text:"Users"
                font.pixelSize: parent.height*0.4
                color: qgcPal.text
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.height*0.4
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
            radius: 6

            Rectangle{
                id: createbtn
                width: parent.width*0.1
                height: parent.height*0.065
                color: qgcPal.buttonHighlight
                border.color: qgcPal.windowShade
                border.width: 1
                anchors.right: parent.right
                anchors.top:parent.top
                anchors.topMargin: parent.height*0.04
                anchors.rightMargin: parent.height*0.04
                radius: 6

                Image{
                    id: create
                    source: "/custom/img/AddUser.png"
                    width: parent.width*0.2
                    height: parent.width*0.2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.height*0.6
                }

                Text {
                    text: qsTr("Create")
                    color: qgcPal.text
                    font.pixelSize: parent.width*.1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: create.right
                    anchors.leftMargin: parent.width*0.1
                }

                MouseArea{
                    id: createbtnmousearea
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent

                    hoverEnabled: true

                    onHoveredChanged: {
                        if(containsMouse){
                            createbtn.opacity = 0.7
                        }
                        else{
                            createbtn.opacity = 1
                        }
                    }
                    onPressed: {
                        createbtn.opacity = 0.5
                    }
                    onReleased: {
                        createbtn.opacity = 1
                    }
                    onClicked: {
                        openpopup()
                        mainRect.enabled = false
                        mainRect.opacity = 0.8
                        userregister.visible = true
                        userregister.enabled = true
                        userregister.regUserid = ""
                        userregister.regPassword = ""
                        userregister.errorfieldtxt = ""
                        userregister.bgrect = "lightgrey"
                        userregister.combobox.currentIndex = 0
                        userregister.passwordHide = true
                        userregister.submitbuttontxt.text = "CREATE"
                        userregister.heading = "USER REGISTRATION"
                    }
                }
            }

            Rectangle{
                id: searchbar
                width: parent.width*0.4
                height: parent.height*0.065
                color: "transparent"
                radius: 6
                border.color: qgcPal.buttonHighlight
                border.width: 1
                anchors.left: parent.left
                anchors.top:parent.top
                anchors.topMargin: parent.height*0.04
                anchors.leftMargin: parent.height*0.04

                TextField{
                    id: searchval
                    text: ""
                    font.pixelSize: parent.height*0.41
                    textColor: qgcPal.text
                    placeholderText: "Search User"
                    height: parent.height
                    width: parent.width*0.7
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:parent.left
                    anchors.leftMargin: parent.height*0.15

                    style: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }

                    onTextChanged:{
                        if(text == ""){
                            roleModel.resetModel()
                        }
                    }
                }

                Rectangle{
                    id: cross
                    height: parent.height
                    width: parent.width*0.08
                    color: "transparent"
                    anchors.left: searchval.right
                    anchors.right: searchbtn.left
                    Text {
                        id:txt1id
                        text: qsTr("+")
                        rotation: 45
                        color: qgcPal.text
                        anchors.centerIn: parent
                        font.pixelSize: parent.width*0.5
                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onHoveredChanged: {
                            if(containsMouse){
                                cross.opacity = 0.7
                            }
                            else{
                                cross.opacity = 1
                            }
                        }


                        onPressed: {
                            cross.opacity = 0.5
                        }

                        onReleased: {
                            cross.opacity = 1
                        }
                        onClicked: {
                            searchval.text = ""
                        }
                    }
                }

                Rectangle{
                    id: searchbtn
                    width: parent.width*0.2
                    height: parent.height*0.95
                    color: qgcPal.buttonHighlight
                    radius: 6
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: parent.height*0.04

                    Text{
                        id: searchtxt
                        text: "Search"
                        anchors.centerIn: parent
                        font.pixelSize: parent.height*0.4
                        color: qgcPal.text
                    }

                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onHoveredChanged: {
                            if(containsMouse){
                                searchbtn.opacity = 0.7
                            }
                            else{
                                searchbtn.opacity = 1
                            }
                        }

                        onPressed: {
                            searchbtn.opacity = 0.5
                        }
                        onReleased: {
                            searchbtn.opacity = 1
                        }
                        onClicked: {
                            if(searchval.text != ""){
                                roleModel.filterModel(searchval.text)
                            }
                        }
                    }
                }
            }

            Rectangle{
                id: tableRect
                width: parent.width*0.97
                height: parent.height*0.7
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: createbtn.bottom
                anchors.topMargin: parent.height*0.1
                color:"transparent"

                TableView {
                    id: tableviewcomp
                    anchors.fill: parent
                    backgroundVisible: false
                    frameVisible: true
                    verticalScrollBarPolicy: ScrollBar.AsNeeded  // You can use ScrollBar.AlwaysOff or ScrollBar.AsNeeded as well
                    model: roleModel
                    horizontalScrollBarPolicy: ScrollBar.AlwaysOff

                    TableViewColumn {
                        role: "userid"
                        title: "userid"
                        width: tableviewcomp.width*.186

                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.height*0.1
                                    text: model ? qsTr(styleData.row+1 + ". " + model.userid) : ""  // Display the setup or any other data
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
                        role: "role"
                        title: "role"
                        width: tableviewcomp.width*.149

                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: model ? rolepermModel.getRoleParameter(styleData.row,"rolename") : ""
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
                        role: "isactive"
                        title: "isactive"
                        width: tableviewcomp.width*.086

                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Image {
                                    source: model ? (model.isactive == "1") ? "/custom/img/ActiveUserIcn.png" : "/custom/img/InactiveUserIcn.png" : ""
                                    height: parent.height*.7
                                    width: parent.height*.7
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }

                    TableViewColumn {
                        role: "usersince"
                        title: "usersince"
                        width: tableviewcomp.width*0.211


                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.height*0.1
                                    text: model && model.usersince != "-" ? opCls.getDateTime(model.usersince) : "-"
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
                        role: "lastlogin"
                        title: "lastlogin"
                        width: tableviewcomp.width*0.211


                        delegate: Item {
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"


                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.height*0.1
                                    text: model && model.lastlogin != "-" ? opCls.getDateTime(model.lastlogin) : "-"
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
                        role: "edituser"
                        title: "edituser"
                        width: tableviewcomp.width*0.08

                        delegate: Item {
                            Rectangle {
                                id: edituserbtn
                                width: parent.width
                                height: parent.height
                                color: "transparent"
                                Image {
                                    source: model ? model.edituser : ""//model.edituser
                                    height: parent.height*.7
                                    width: parent.height*.7
                                    anchors.centerIn: parent

                                }
                                MouseArea{
                                    id: edituserbtnmousearea
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onPressed: {
                                        edituserbtn.opacity = 0.5
                                    }

                                    onReleased: {
                                        edituserbtn.opacity = 1
                                    }

                                    onClicked: {
                                        openpopup()
                                        rowSelected = styleData.row
                                        username = model.userid
                                        userregister.passwordValid = true
                                        console.log("styleData.row === ",styleData.row)
                                        mainRect.enabled = false
                                        mainRect.opacity = 0.8
                                        userregister.visible = true
                                        userregister.enabled = true
                                        userregister.regUserid = model.userid
                                        userregister.regPassword = model.password
                                        userregister.errorfieldtxt = ""
                                        userregister.bgrect = "lightgrey"
                                        userregister.combobox.currentIndex = userregister.combobox.indexOfValue(rolepermModel.getRoleParameter(styleData.row,"rolename"))
                                        userregister.passwordHide = true
                                        userregister.submitbuttontxt.text = "EDIT"
                                        userregister.heading = "EDIT USER DATA"
                                    }
                                }
                            }
                        }
                    }
                    TableViewColumn {
                        role: "deleteuser"
                        title: "deleteuser"
                        width: tableviewcomp.width*0.079

                        delegate: Item {
                            Rectangle {
                                id: deletebtn
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                Image {
                                    source: (model) ? model.deleteuser : ""
                                    height: parent.height*.7
                                    width: parent.height*.7
                                    anchors.centerIn: parent
                                }
                                MouseArea{
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onPressed: {
                                        deletebtn.opacity = 0.5
                                    }

                                    onReleased: {
                                        deletebtn.opacity = 1
                                    }

                                    onClicked: {
                                        console.log("delete item = ",styleData.row)
                                        var user = model.userid
                                        mainWindow.showMessageDialog("Deleting User",
                                                                     qsTr("Are you sure you want to Delete User?"),
                                                                     StandardButton.Yes | StandardButton.No,
                                                                     function() {
                                                                         //delete the user
                                                                         roleModel.deleteData(styleData.row)
                                                                         dstDb.deleteUser(user)
                                                                         //tableviewcomp.setModel(nullptr)

                                                                     })
                                    }
                                }
                            }
                            // Image {
                            //     id: line
                            //     // visible: styleData.row===5? false : true
                            //     source: "img/LineIcon.svg"
                            //     height: parent.height*.03
                            //     width: parent.width*95
                            //     x: parent.width*(-5.5)
                            //     y: parent.height*1
                            // }
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
                            width: tableviewcomp.width*0.186
                            anchors.left: parent.left
                            color: qgcPal.buttonHighlight
                            border.color:qgcPal.toolbarBackground
                            // anchors.leftMargin:tableviewcomp.width*0.05

                            Text {
                                id: vechidtxt
                                text: qsTr("User ID")
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
                            width: tableviewcomp.width*0.149
                            anchors.left: rect1.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: firmwaretype
                                text: qsTr("Role")
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
                            width: tableviewcomp.width*0.086
                            anchors.left: rect2.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: vehicletype
                                text: qsTr("Status")
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
                            width: tableviewcomp.width*0.211
                            anchors.left: rect3.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: selected
                                text: qsTr("Reg. Date")
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
                            width: tableviewcomp.width*0.211
                            anchors.left: rect4.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: lastlogin
                                text: qsTr("Last Login")
                                color: qgcPal.text
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                drag.target: null // Disable dragging
                            }
                        }
                        Rectangle{
                            id: rect6
                            height: parent.height
                            width: tableviewcomp.width*0.08
                            anchors.left: rect5.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: editbtn
                                text: qsTr("Edit")
                                color: qgcPal.text
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                drag.target: null // Disable dragging
                            }
                        }

                        Rectangle{
                            id: rect7
                            height: parent.height
                            width: tableviewcomp.width*0.079
                            anchors.left: rect6.right
                            color: qgcPal.buttonHighlight
                            border.color: qgcPal.toolbarBackground

                            Text {
                                id: deletebutton
                                text: qsTr("Delete")
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

        // Rectangle{
        //     id: userid
        //     width: tableRect.width*.186
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: tableRect.left
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("User ID")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

        // Rectangle{
        //     id: userrole
        //     width: tableRect.width*.149
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: userid.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("Role")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

        // Rectangle{
        //     id: isactive
        //     width: tableRect.width*.086
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: userrole.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("Status")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

        // Rectangle{
        //     id: usersince
        //     width: tableRect.width*.211
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: isactive.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("User Since")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

        // Rectangle{
        //     id: lastlogin
        //     width: tableRect.width*.211
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: usersince.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("Last Login")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

        // Rectangle{
        //     id: edit
        //     width: tableRect.width*.08
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: lastlogin.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("Edit")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

        // Rectangle{
        //     id: deleteuser
        //     width: tableRect.width*.079
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: edit.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("Delete")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }


    }

    UserRegister{
        id: userregister
        anchors.fill: parent
        visible: false
        enabled: false

        submitbuttonmousearea.onClicked:{
            if(regUserid != "" &&  regPassword != ""){

                if(passwordValid == true){
                    bgrect = "lightgrey"
                    if(submitbuttontxt.text == "CREATE"){
                        if(roleModel.userExists(regUserid) == -1){
                            closepopup()
                            //add user to DB and listmodel
                            opCls.userRegistration(regUserid,regPassword,combobox.currentIndex)
                            userregister.visible = false
                            userregister.enabled = false
                            mainRect.enabled = true
                            mainRect.opacity = 1
                        }else{
                            errorfieldtxt = "User ID Already Exists"
                        }

                    }else if(submitbuttontxt.text == "EDIT"){
                        if(roleModel.userExists(regUserid) == -1 || regUserid == username){
                            closepopup()
                            mainWindow.showMessageDialog("Editing User",
                                                         qsTr("Are you sure you want to Save Changes?"),
                                                         StandardButton.Yes | StandardButton.No,
                                                         function() {
                                                             //delete the user
                                                             opCls.editUserData(rowSelected+1, regUserid, regPassword, combobox.currentIndex)
                                                         })
                            userregister.visible = false
                            userregister.enabled = false
                            mainRect.enabled = true
                            mainRect.opacity = 1
                        }else{
                            errorfieldtxt = "User ID Already Exists"
                        }
                    }else{;}
                }else{
                    bgrect = "red"
                    errorfieldtxt = "Created Password is of wrong format"
                }
            }else{
                errorfieldtxt = "User ID/Password cannot be Empty !"
            }
        }


        closebuttonmousearea.onClicked: {
            closepopup()
            mainRect.enabled = true
            mainRect.opacity = 1
            userregister.visible = false
            userregister.enabled = false
        }
    }
}
