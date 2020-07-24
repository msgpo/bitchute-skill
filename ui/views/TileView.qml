/*
 *  Copyright 2019 Aditya Mehra <aix.m@outlook.com>
 *  Copyright 2019 Marco Martin <mart@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.4 as Controls
import org.kde.kirigami 2.5 as Kirigami

Item {
    id: root
    signal activated
    property string title
    property alias view: view
    property alias delegate: view.delegate
    property alias model: view.model
    property alias currentIndex: view.currentIndex
    property alias currentItem: view.currentItem
    Layout.fillWidth: true
    
    implicitHeight: view.implicitHeight + header.implicitHeight

    //TODO:dynamic
    property int columns: Math.max(3, Math.floor(width / (Kirigami.Units.gridUnit * 8)))

    property alias cellWidth: view.cellWidth
    property alias cellHeight: view.cellHeight
    readonly property real screenRatio: view.Window.window ? view.Window.window.width / view.Window.window.height : 1.6

    Kirigami.Heading {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: title
        layer.enabled: true
        color: "white"
    }
    
    ListView {
        id: view
        anchors {
            left: parent.left
            right: parent.right
            top: header.baseline
            bottom: parent.bottom
            topMargin: Kirigami.Units.largeSpacing*2
            leftMargin: -Kirigami.Units.largeSpacing
        }

        z: activeFocus ? 10: 1
        keyNavigationEnabled: false
        snapMode: ListView.SnapToItem
        cacheBuffer: width
        implicitHeight: cellHeight
        rightMargin: width-cellWidth
        property int cellWidth: parent.width / 3
        property int cellHeight: cellWidth + Kirigami.Units.gridUnit * 3
        displayMarginBeginning: cellWidth
        displayMarginEnd: cellWidth

        onContentWidthChanged: if (view.currentIndex === 0) view.contentX = view.originX

        onMovementEnded: flickEnded()
        onFlickEnded: currentIndex = indexAt(mapToItem(contentItem, cellWidth, 0).x, 0)
        
        spacing: 0
        orientation: ListView.Horizontal

        move: Transition {
            SmoothedAnimation {
                property: "x"
                duration: Kirigami.Units.longDuration
            }
        }
    }
}
