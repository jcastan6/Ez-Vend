import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  Form,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Carousel
} from "react-bootstrap";
import "../app.css";

import { saveCookie } from "./Cookies";

export default class Upload extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      description: "",
      hashtags: []
    };
  }

  handleChange = event => {
    this.setState({
      [event.target.id]: event.target.value
    });
  };

  handleSubmit = event => {
    event.preventDefault();
    fetch("http://54.177.22.144:3001/images/new", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json"
      }
    })
      .then(res => res.json())
      .then(res => {
        if (res.status === 401) {
          alert("Sorry please check log-in credentials");
        } else if (res.password === true) {
          saveCookie(res.userid);
          this.handleRouteChange();
        } else {
          const error = new Error(res.error);
          throw error;
        }
      })
      .catch(err => {
        alert("Error logging in please try again");
        console.error(err);
      });
  };

  handleRouteChange() {
    // window.location.reload(false);
  }

  validateForm() {
    return this.state.description.length > 0;
  }

  render() {
    return (
     
    );
  }
}
