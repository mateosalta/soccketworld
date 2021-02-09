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
    // property names are preaty clean no need to describe each of them.
    property alias country_name: countryNameLabel.text
    property alias country_voltage: voltageLabel.text
    property alias country_frequency: frequencyLabel.text
    property alias country_plugs: countryPlugsLabel.text
    property alias country_flag_src: image_flag.source
    property alias country_map_src: image_map.source
    property int itemView_Page_y: itemViewPage_header.y

    // header on country preview contains: Flag image, map image, and few labels.
    Item {
        id: itemViewPage_header
        width: parent.width - units.gu(4)
        height: image_flag.height + labelsColumn.height + units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter
        y: itemView_Page_y
        Behavior on y {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.BriskDuration
            }
        }

        // flag image
        Image {
            id: image_flag
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: units.gu(2)
            fillMode: Image.PreserveAspectCrop
            width: units.gu(15)
        }

        // drop shadow for flag image
        DropShadow {
            anchors.fill: image_flag
            horizontalOffset: 3
            verticalOffset: 3
            radius: 3.0
            samples: 16
            color: "#80000000"
            source: image_flag
        }

        // map image
        Image {
            id: image_map
            anchors.right: parent.right
            anchors.top: image_flag.top
            fillMode: Image.PreserveAspectFit
            height: units.gu(25)
        }
        // drop shadow for map image
        DropShadow {
            anchors.fill: image_map
            horizontalOffset: 3
            verticalOffset: 3
            radius: 3.0
            samples: 16
            color: "#80000000"
            source: image_map
        }

        // item to holds column with labels ( country name, voltage, frequency and sockets )
        Item {
            id: labelsColumn
            height: countryNameLabel.height + voltageLabel.height + frequencyLabel.height + countryPlugsLabel.height
            anchors.top: image_flag.bottom
            anchors.left: image_flag.left
            anchors.leftMargin: units.gu(1)
            Column {
                anchors.fill: parent
                spacing: units.gu(0.3)
                // country name
                Label {
                    id: countryNameLabel
                    fontSize: "large"
                    color: "#003355"
                }
                // voltage
                Label {
                    id: voltageLabel
                    color: "#003355"
                }
                // frequency
                Label {
                    id: frequencyLabel
                    color: "#003355"
                }
                // plugs
                Label {
                    id: countryPlugsLabel
                    color: "#003355"
                }
            }
        }
    }

    // item to holds ListView with all plugs and sockets used in selected country.
    Item {
        width: parent.width - units.gu(5)
//        width: (mainView.width/3)*2 - units.gu(1)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: itemViewPage_header.bottom
        anchors.bottom: parent.bottom
        ListView {
            id: listViewTest1
            anchors.fill: parent
            model: plugImagesMODEL
            clip: true
            section.property: "image"
            section.criteria: ViewSection.FirstCharacter
            section.delegate: ListItem.Header { text: '<font color="#003355">Plug '+section+"</font></b>" }
            delegate: ListView {
                width: (mainView.width/3)*2 - units.gu(6)
                height: units.gu(17)
                spacing: units.gu(2)
                model: plugImagesDetailsMODEL
                orientation: ListView.Horizontal
                delegate: CategoryDelegate {
                    width: units.gu(15)
                    height: units.gu(15)
                    thumbnail: Qt.resolvedUrl("../img/plugs/%.png").arg(image+view)
                    onClick: {
//                        soundEffect_click.play()
                        plug_preview_src = Qt.resolvedUrl("../img/plugs/%.png").arg(image+view)
                        plug_preview_label = slicingStringForPlugPrevie(image, view)
                        plugPreview.opacity = 1
                        preview_width = mainView.width - units.gu(4)
                        preview_heigth = mainView.height - units.gu(12)
//                        itemView_PageTools = true
                    }
                }
            }
        }
    }
}
