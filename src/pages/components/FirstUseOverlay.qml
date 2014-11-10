/****************************************************************************
**
** Copyright (C) 2013, 2014 Jolla Ltd.
** Contact: Vesa-Matti Hartikainen <vesa-matti.hartikainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

import QtQuick 2.1
import Sailfish.Silica 1.0


SilicaFlickable {
    property double startY
    property double gestureThreshold

    // These properties allows us to fake the FirstUseOverlay
    // for OverlayAnimator to be similar to WebView itself.
    property real fullscreenHeight
    property bool fullscreenMode

    function done() {
        if (!WebUtils.firstUseDone) {
            WebUtils.firstUseDone = true
        }
        dismiss()
    }

    function dismiss() {
        visible = false
        firstUseOverlay = null
        webView.visible = true
        destroy()
    }

    contentHeight: contentColumn.height
    z: -1
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.VerticalFlick

    onFlickStarted: startY = contentY
    onFlickEnded: startY = contentY

    onContentYChanged: {
        var offset = contentY
        var currentDelta = offset - startY

        if (currentDelta > gestureThreshold) {
            startY = contentY
            currentDelta = 0
            fullscreenMode = true
        } else if (currentDelta < -gestureThreshold) {
            startY = contentY
            currentDelta = 0
            fullscreenMode = false
        }
    }

    Column {
        id: contentColumn
        anchors {
            margins: Theme.paddingLarge
            top: parent.top
            left: parent.left
            right: parent.right
        }
        spacing: Theme.paddingLarge
        height: window.height + gestureThreshold * 8

        FirstUseTip {
            //: Hello, here's few tips about the browser toolbar
            //% "Hello, here's few tips about the browser toolbar"
            text: qsTrId("sailfish_browser-he-first_use")
            header: true
        }

        FirstUseTip {
            //: Tab to go to previous or next page
            //% "Tab to go to previous or next page"
            text: qsTrId("sailfish_browser-la-first_use_navigation_hint")
            iconSource: "image://theme/icon-m-back"
        }

        FirstUseTip {
            //: Mark a page as favorite for easy access later on
            //% "Mark a page as favorite for easy access later on"
            text: qsTrId("sailfish_browser-la-first_use_bookmark_hint")
            iconSource: "image://theme/icon-m-favorite"
        }

        FirstUseTip {
            //: Switch between open tabs, edit the address of the current one or open a bookmark
            //% "Switch between open tabs, edit the address of the current one or open a bookmark"
            text: qsTrId("sailfish_browser-la-first_use_tabs_hint")
            iconSource: "image://theme/icon-m-tabs"
        }

        FirstUseTip {
            //: Reload the page
            //% "Reload the page"
            text: qsTrId("sailfish_browser-la-first_reload_hint")
            iconSource: "image://theme/icon-m-refresh"
        }

        FirstUseTip {
            //: Now, try moving this text up to hide the toolbar.
            //% "Now, try moving this text up to hide the toolbar."
            text: qsTrId("sailfish_browser-la-first_hide_toolbar_hint")
        }
    }

    Label {
        //: Flick down to reveal the toolbar
        //% "Flick down to reveal the toolbar"
        text: qsTrId("sailfish_browser-la-toolbar_hint")
        wrapMode: Text.WordWrap
        width: parent.width - Theme.paddingLarge
        color: Theme.highlightColor
        anchors {
            bottom: parent.bottom; bottomMargin: Theme.paddingLarge
            left: parent.left; leftMargin: Theme.paddingLarge
            horizontalCenter: parent.horizontalCenter
        }
    }
}
