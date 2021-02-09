/*
 * Copyright (C) 2014 Szymon Waliczek.
 *
 * Authors:
 *  Szymon Waliczek <majsterrr@gmail.com>
 *
 * This file is part of SocketWorld app for Ubuntu Touch
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../components"


Item {
    property string plug/*: plug_label.text*/
    property string used_in/*: used_in_label.text*/
    property alias full_info: full_info_label2.text



    ListModel {
        id: plugImagesMODEL
        ListElement { view: "_3d_plug_l" }
        ListElement { view: "_3d_socket_l" }
        ListElement { view: "_diagram_plug_l" }
        ListElement { view: "_diagram_socket_l" }
    }
    Column {
        width: parent.width
        height: parent.height
//        spacing: units.gu(2)
        Behavior on width {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.BriskDuration
            }
        }
        Item {
            id: column_header
            width: parent.width
            height: plug_label.height + plugs_listView.height  + units.gu(3)

            Column {
                anchors.fill: parent
                anchors.margins: units.gu(2)
                spacing: units.gu(1)
                clip: true
                Text {
                    id: plug_label
                    wrapMode: Text.WordWrap
                    color: "#003355"
                    font.pixelSize: units.gu(2.2)
                    text: "<b>"+i18n.tr("Plug ") + plug + "</b>"
                }
                ListView {
                    id: plugs_listView
                    model:plugImagesMODEL
                    width: parent.width
                    height: units.gu(19)
                    spacing: units.gu(2)
                    orientation: ListView.Horizontal
                    delegate: CategoryDelegate {
                        width: units.gu(17)
                        height: units.gu(17)
//                        label: view
                        thumbnail: Qt.resolvedUrl("../img/plugs/%.png").arg(plug+view)
                    }
                }
            }
        }

        //Seperator
        Item {
            width: parent.width
            height: units.gu(1)
            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.2
            }
        }

        //Used in Label
        Item {
            id: button_full_list_item
            width: parent.width
            height: button_full_list.height + units.gu(2)
            Button {
                id: button_full_list
                width: parent.width - units.gu(4)
                height: units.gu(4)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "#003355"
                text: "Full list of countries where Plug "+ selected_plug + " is used"
                onClicked: pagestack_plugsANDsockets.push(plugs_Page_list_of_countries)
            }
        }

        Text {
            id: full_info_label1
            width: parent.width
            anchors.left: parent.left
            anchors.leftMargin: units.gu(2)
            wrapMode: Text.WordWrap
            font.pixelSize: units.gu(2.2)
            color: "white"
            text: "<b>"+i18n.tr("Information: ") + "</b>"
        }



        // Full Information flickale
        Item {
            width: parent.width
            height: parent.height - button_full_list_item.height - column_header.height - full_info_label1.height - units.gu(2)

            Flickable {
                width: parent.width
                height: parent.height
                contentWidth: parent.width
                contentHeight: full_info_label2.height + units.gu(1)
                clip: true
                Column {
                    anchors.fill: parent
                    anchors.leftMargin: units.gu(2)
                    anchors.rightMargin: units.gu(2)
//                    anchors.margins: units.gu(2)
                    spacing: units.gu(1)


                    Text {
                        id: full_info_label2
                        width: parent.width
                        wrapMode: Text.WordWrap
                        font.pixelSize: units.gu(2.2)
                        color: "#003355"
                    }
                }

            }

        }


    }
}
