'use strict';

var React = require('react-native');
var {
  Animated,
  PanResponder,
  Text,
  View,
} = React;

var styles = require('./../styles/text');

const DismissableText = React.createClass({
  // PanResponder object for drag and drop
  _panResponder: {},

  getInitialState: function () {
    return {
      pan: new Animated.ValueXY()
    }
  },

  getDefaultProps: function () {
    return {
      text: ""
    }
  },

  componentWillMount: function () {
    // Set up the PanResponder object.
    this._panResponder = PanResponder.create({
      onStartShouldSetPanResponder: () => true,
      onPanResponderMove: Animated.event([null, {
        dx: this.state.pan.x,
        dy: this.state.pan.y
      }]),
      onPanResponderRelease: this._handlePanResponderEnd,
      onPanResponderTerminate: this._handlePanResponderEnd
    })
  },

  // Determines if the dragged text should be dismissed or return to its place
  // in the scrolling view.
  _handlePanResponderEnd: function () {
    let newX,
        threshold = 150,
        endPosition = this.state.pan.getLayout().left._value;

    // If the end position is greater than the threshold, dismiss the text
    // in the correct direction.
    newX = endPosition > threshold ? 1000 : (endPosition < -threshold ? -1000 : 0);

    // Animate the element off the screen
    Animated.timing(
      this.state.pan,
      {
        duration: 100,
        toValue: {x: newX, y: 0},
      }
    ).start()
  },

  render: function () {
    return (
      <Animated.View
        style={[this.state.pan.getLayout(), {backgroundColor: 'transparent'}]}
        {...this._panResponder.panHandlers} >
        <Text style={[styles.dismissableText]}>
          {this.props.text}
        </Text>
      </Animated.View>
    )
  }
});

module.exports = DismissableText;
