import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Form,
  Card,
} from "react-bootstrap";
import Modal from "react-modal";

import { BsFillXSquareFill, BsThreeDotsVertical } from "react-icons/bs";
import "./Maintenances.css";

class TaskEditor extends Component {
  constructor(props) {
    super(props);
    this.showReminder = this.showReminder.bind(this);
    this.state = {
      id: this.props.task.id,
      task: this.props.task.task,
      recurring: this.props.task.recurring,
      reminderAt: this.props.task.reminderAt,
      priority: this.props.task.priority,
      showModal: false,
    };

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    this.showReminder();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://127.0.0.1:3001/machines/editMaintenanceTask", {
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
        this.handleCloseModal();
      });
  };

  delete = () => {
    fetch("http://127.0.0.1:3001/machines/deleteMaintenanceTask", {
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

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  validateForm() {
    return this.state.task.length > 0 && this.state.priority !== null;
  }

  showReminder() {
    return (
      <FormGroup controlId="reminderAt">
        <FormLabel>Remind Every:</FormLabel>
        <FormControl
          autoFocus
          type="type"
          value={this.state.reminderAt}
          onChange={this.handleChange}
        />
        Days
      </FormGroup>
    );
  }

  render() {
    return (
      <div>
        <BsThreeDotsVertical onClick={this.handleOpenModal} />

        <Modal
          shouldCloseOnOverlayClick
          onRequestClose={this.handleCloseModal}
          isOpen={this.state.showModal}
          className="modal-form"
        >
          <Card>
            <Card.Body>
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

                {this.showReminder()}

                <Button
                  block
                  disabled={!this.validateForm()}
                  type="submit"
                  onClick={this.onSubmit}
                >
                  Update
                </Button>
                <Button
                  block
                  disabled={!this.validateForm()}
                  variant="danger"
                  onClick={this.delete}
                >
                  Delete
                </Button>
              </form>
            </Card.Body>
          </Card>
        </Modal>
      </div>
    );
  }
}
export default TaskEditor;
