import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import Modal from "react-modal";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Card,
  Carousel,
  Container,
  Jumbotron,
  Row,
  Col,
} from "react-bootstrap";
import "./Maintenances.css";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";
import { BsCamera } from "react-icons/bs";
import maintenanceHistory from "../../../server/models/maintenanceHistory";

class ReportEditor extends Component {
  constructor(props) {
    super(props);

    this.state = {
      task: this.props.report.task,
      id: this.props.report.id,
    };

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://localhost:3000/machines/editMaintenanceReport", {
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

  delete = () => {
    fetch("http://localhost:3000/machines/deleteMaintenanceReport", {
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
    return this.state.task.length > 0;
  }

  render() {
    return (
      <div>
        <Card>
          <Card.Body>
            <form onSubmit={this.handleSubmit}>
              <FormGroup controlId="task">
                <FormLabel>Report:</FormLabel>
                <FormControl
                  autoFocus
                  type="type"
                  value={this.state.task}
                  onChange={this.handleChange}
                />
              </FormGroup>

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
      </div>
    );
  }
}
export default ReportEditor;
