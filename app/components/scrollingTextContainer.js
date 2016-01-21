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
var TimerMixin = require('react-timer-mixin')

const styles = require('./../styles/view')
const textStyles = require('./../styles/text')
const DismissableText = require('./dismissableText')

const ScrollingTextContainer = React.createClass({
  mixins: [TimerMixin],

  // Generates unique GUIDs for use in generating new text elements
  // from http://stackoverflow.com/a/2117523/5108714
  _generateGUID: function () {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  },

  // Generates a new DismissableText element
  _generateDismissableTextElement: function () {
    let key = this._generateGUID()
    return (
      <DismissableText text={this.props.phrase} key={key} elementDismissed={this._elementDismissed} />
    )
  },


  _generateDistortedTextElement: function (text) {
    // Generate some random transformations
    let transformations = [
      {rotate: (Math.floor(Math.random() * 360) + 'deg')},
      {perspective: (Math.floor(Math.random() * 90)) + 1},
      {scale: (Math.random() * 2 * this.state.distortedViews.length)},
      {translateX: (Math.random() * 350)},
      {translateY: (Math.random() * 100)}
    ]

    // Get a random set of transformations
    transformations.sort( function() { return 0.5 - Math.random() } )
    let numDistortions = Math.floor(Math.random() * 5)

    // Generate the key
    let key = this._generateGUID()

    return (
      <Text
        key={key}
        style={[textStyles.dismissableText], {
          transform: transformations.slice(numDistortions),
          fontSize: 50
        }}>
        {text}
      </Text>
    )
  },

  _generateDistortedView : function (text) {
    let els = []
    for (var i = 0; i < 8; ++i) {
      els.push(this._generateDistortedTextElement());
    }

    this.setState({distortedViews: [...this.state.distortedViews, els]}, () => {
      if (this.state.distortedViews.length > 1) {
        this.setTimeout(() => {
          Animated.timing(
            this.state.viewOpacity,
            {
              duration: 3000,
              toValue: 0,
              easing: Easing.linear
            }
          ).start(() => {
            this.props.navigator.replace({
              name: 'InfoScreen'
            })
          })
        }, 10000)
      }
    })
  },

  _elementDismissed: function () {
    this.setState({numDismissed: (this.state.numDismissed + 1)}, () => {
      if (this.state.numDismissed % 5 === 0) {
        this._generateDistortedView();
      }
    })
  },

  scrollingAnimation: function (duration) {
    Animated.timing(
      this.state.bottomAnim, // Value being animated
      {
        duration: (duration * (3/this.state.numDismissed)),
        easing: Easing.linear, // Uses linear easing so the user can't perceive breaks in animation
        toValue: 60 // This value is the height of 1 text element
      }
    ).start(() => { // Animation callback
      // Generate text element and create a new array of elements; discards the
      // first element and appends the newly created element.
      let distortedViews = this.state.distortedViews
      for (var i = 0; i < distortedViews.length; i++) {
        var currentView = distortedViews[i]

        var newElement
        if (Math.floor(Math.random() * this.state.numDismissed) > 3) {
          newElement = this._generateDistortedTextElement(this.props.phrase)
        } else {
          newElement = this._generateDistortedTextElement();
        }

        let distortedElements = [...currentView.slice(1), newElement]
        distortedViews[i] = distortedElements
      }

      let elements = [...this.state.elements.slice(1), this._generateDismissableTextElement()]

      // Put the new elements array in the component state
      this.setState({elements: elements, distortedViews: distortedViews}, () => {
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
      elements: [],
      distortedViews: [],
      numDismissed: 1,
      viewOpacity: new Animated.Value(0),
      fadeToBlackColor: "FFFFFF"
    }
  },

  componentWillMount: function () {
    // Initialize the component with 8 text elements
    let startingText = []
    let distortedText = []
    for (let i = 0; i < 8; i++) {
      var el = this._generateDismissableTextElement();
      startingText.push(el)
    }
    this.setState({elements: startingText});
  },

  componentDidMount: function () {
    // Start the scrolling text
    this.scrollingAnimation(1000);
    Animated.timing(
      this.state.viewOpacity,
      {toValue: 1}
    ).start(() => {
      this.setState({fadeToBlackColor: "000000"})
    });
  },

  render: function() {
    let dist = this.state.distortedViews.map((elements) => {
      let key = this._generateGUID();
      return (
        <Animated.View
          key={key}
          style={[styles.centeredContainer, {bottom: this.state.bottomAnim, position: 'absolute'}]}>
          {elements}
        </Animated.View>
      )
    })

    return (
      <View>
        <Animated.View style={{
            backgroundColor: this.state.fadeToBlackColor,
            opacity: this.state.viewOpacity.interpolate({
              inputRange: [0, 1],
              outputRange: [1, 0]
            }),
            flex: 1,
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0
          }}></Animated.View>
        <Animated.View
          style={[styles.centeredContainer, {bottom: this.state.bottomAnim, opacity: this.state.viewOpacity}]}>
          {this.state.elements}
        </Animated.View>
        {dist}
      </View>
    );
  }
});

module.exports = ScrollingTextContainer;
