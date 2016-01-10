/**
 * Scrolling Text Container
 * A container with scrolling dismissable text components
 */
'use strict';

var React = require('react-native');
var {
  Animated,
  AppRegistry,
  Easing,
  StyleSheet,
  Text,
  View,
} = React;

const styles = require('./../styles/view');
const DismissableText = require('./dismissableText');

const ScrollingTextContainer = React.createClass({
  // Generates unique GUIDs for use in generating new text elements
  // from http://stackoverflow.com/a/2117523/5108714
  _generateGUID: function () {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  },

  // Generates a new DismissableText element
  _generateTextElement: function () {
    let key = this._generateGUID()
    return (
      <DismissableText text={this.props.phrase} key={key} />
    )
  },

  scrollingAnimation: function (duration) {
    Animated.timing(
      this.state.bottomAnim, // Value being animated
      {
        duration: duration,
        easing: Easing.linear, // Uses linear easing so the user can't perceive breaks in animation
        toValue: 60 // This value is the height of 1 text element
      }
    ).start(() => { // Animation callback
      // Generate text element and create a new array of elements; discards the
      // first element and appends the newly created element.
      let newElement = this._generateTextElement();
      let elements = [...this.state.elements.slice(1), newElement];

      // Put the new elements array in the component state
      this.setState({elements: elements}, () => {
        // Loop the animation
        this.state.bottomAnim.setValue(0);
        this.scrollingAnimation(1000);
      })
    })
  },

  getDefaultProps: function () {
    return {
      phrase: "I'M NOT GOOD ENOUGH"
    }
  },

  getInitialState: function () {
    return {
      bottomAnim: new Animated.Value(0),
      elements: []
    }
  },

  componentWillMount: function () {
    // Initialize the component with 8 text elements
    let startingText = []
    for (let i = 0; i < 8; i++) {
      var el = this._generateTextElement();
      startingText.push(el)
    }
    this.setState({elements: startingText});
  },

  componentDidMount: function () {
    // Start the animation
    this.scrollingAnimation(1000);
  },

  render: function() {
    return (
      <Animated.View
        style={[styles.centeredContainer, {bottom: this.state.bottomAnim}]}>
        {this.state.elements}
      </Animated.View>
    );
  }
});

module.exports = ScrollingTextContainer;
