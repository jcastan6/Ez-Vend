import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Form,
  Image,
  Carousel,
} from "react-bootstrap";

class NewMaintenance extends Component {
  constructor(props) {
    super(props);
    this.showReminder = this.showReminder.bind(this);
    this.state = {
      machineType: this.props.type,
      task: "",
      priority: null,
      recurring: false,
      reminderCount: null,
    };
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
    console.log(this.state);
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://localhost:4000/machines/newMaintenanceTask", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    }).then(() => {
      this.props.getMaintenances();
    });
  };

  validateForm() {
    if (this.state.task.length > 0 && this.state.reminderCount) {
      return true;
    }

    return false;
  }

  showReminder() {
    return (
      <FormGroup controlId="reminderCount">
        <FormLabel>Remind Every:</FormLabel>
        <FormControl
          autoFocus
          type="type"
          value={this.state.reminderCount}
          onChange={this.handleChange}
        />
        Days
      </FormGroup>
    );
  }

  render() {
    return (
      <div>
        <h1 id="justice">
          <b>New Maintenance</b>
          <br />
          <h4>Machine : {this.state.machineType} </h4>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit}>
          <FormGroup controlId="task">
            <FormLabel>Task</FormLabel>
            <FormControl
              autoFocus
              type="type"
              value={this.state.task}
              onChange={this.handleChange}
            />
          </FormGroup>

          {this.showReminder()}
          <Button
            block
            disabled={!this.validateForm()}
            type="submit"
            onClick={this.onSubmit}
          >
            Add
          </Button>
        </form>
      </div>
    );
  }
}
export default withRouter(NewMaintenance);
