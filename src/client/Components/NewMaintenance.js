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

    this.state = {
      machineType: this.props.type,
      task: "",
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
    return this.state.task.length > 0;
  }

  render() {
    return (
      <div>
        <h1 id="justice">
          <b>New {this.state.machineType} Maintenance</b>
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
      
          <FormGroup controlId="reminderCount">
            <FormLabel>Remind Every:</FormLabel>
            <FormControl
              autoFocus
              type="type"
              value={this.state.reminderCount}
              onChange={this.handleChange}
            />
            Visits
          </FormGroup>

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
