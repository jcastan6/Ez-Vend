import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Form,
} from "react-bootstrap";
import "../Definitions.css";

class TaskEditor extends Component {
  constructor(props) {
    super(props);

    this.state = {
      id: this.props.task.id,
      task: this.props.task.task,
      recurring: this.props.task.recurring,
      reminderCount: this.props.task.reminderCount,
    };
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://localhost:4000/machines/editMaintenanceTask", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getMaintenances();
      });
  };

  validateForm() {
    return this.state.task.length > 0;
  }

  toggleRecurring = () => {
    this.setState({
      recurring: !this.state.recurring,
    });
  };

  render() {
    return (
      <div className="tab-panel">
        <h1 id="justice">
          <b>Edit Task</b>
        </h1>
        <br />
        <form onSubmit={this.handleSubmit} className="body">
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
            Update
          </Button>
        </form>
      </div>
    );
  }
}
export default withRouter(TaskEditor);
