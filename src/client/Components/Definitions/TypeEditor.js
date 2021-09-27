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
import "../";
import { BsFillXSquareFill, BsThreeDotsVertical } from "react-icons/bs";
import "../Maintenances/Maintenances.css";

class TypeEditor extends Component {
  constructor(props) {
    super(props);

    this.state = {
      id: this.props.type.id,
      type: this.props.type.type,
      showModal: false,
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
    fetch("http://192.168.1.153:4000/machines/editType", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getTypes();
        this.handleCloseModal();
      });
  };

  delete = () => {
    fetch("http://192.168.1.153:4000/machines/deleteType", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getTypes();
      });
  };

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  validateForm() {
    return this.state.type.length > 0;
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
                <b>Edit Type</b>
              </h1>
              <br />
              <form onSubmit={this.handleSubmit} className="body">
                <FormGroup controlId="type">
                  <FormLabel>Type</FormLabel>
                  <FormControl
                    autoFocus
                    type="type"
                    value={this.state.type}
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
        </Modal>
      </div>
    );
  }
}
export default TypeEditor;
