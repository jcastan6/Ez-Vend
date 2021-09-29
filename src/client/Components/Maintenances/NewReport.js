import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Card,
} from "react-bootstrap";
import Modal from "react-modal";
import "./Maintenances.css";
import ImageUploader from "react-images-upload";
import { BsFillPlusSquareFill } from "react-icons/bs";

class NewReport extends Component {
  constructor(props) {
    super(props);
    this.state = {
      machineNo: this.props.machine.machineNo,
      issue: "",
      machines: [],
      pictures: [],
      loading: false,
    };

    this.onDrop = this.onDrop.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
    console.log(this.state);
  };

  handleSubmit = (event) => {
    event.preventDefault();

    const formData = new FormData();
    formData.append("file", this.state.pictures[0]);
    formData.append("machine", this.state.machineNo);
    formData.append("issue", this.state.issue);
    this.setState({
      loading: true,
    }),
      () => console.log();
    fetch("https://www.mantenimientoscvm.com/machines/submitReport", {
      method: "POST",

      body: formData,
    }).then(() => {
      this.props.getMaintenances();
      this.handleCloseModal();
    });
  };

  onDrop(picture) {
    this.setState({
      pictures: this.state.pictures.concat(picture),
    });
  }

  handleOpenModal() {
    this.setState({ showModal: true });
  }

  handleCloseModal() {
    this.setState({ task: "", reminderCount: null, showModal: false });
  }

  validateForm() {
    if (this.state.issue.length > 0) {
      return true;
    }

    return false;
  }

  render() {
    return (
      <div>
        <h4>
          Reportes Abiertos{" "}
          <BsFillPlusSquareFill
            onClick={this.handleOpenModal}
            className="add"
          />
        </h4>

        <Modal
          shouldCloseOnOverlayClick
          onRequestClose={this.handleCloseModal}
          isOpen={this.state.showModal}
          className="modal-form"
        >
          <Card>
            <Card.Body>
              <h5>Agregar Reporte</h5>
              <form onSubmit={this.handleSubmit}>
                <FormGroup className="clientId" controlId="issue">
                  <FormLabel>Reporte</FormLabel>
                  <FormControl
                    size="lg"
                    value={this.state.issue}
                    onChange={this.handleChange}
                  />
                </FormGroup>
                <FormLabel>Fotografía</FormLabel>
                <ImageUploader
                  withIcon
                  buttonText="Escoger Imagen"
                  onChange={this.onDrop}
                  withPreview
                  withLabel={false}
                  imgExtension={[".jpg", ".gif", ".png", ".gif"]}
                  maxFileSize={5242880}
                  singleImage
                />
                <Button
                  disabled={!this.validateForm()}
                  type="submit"
                  onClick={this.onSubmit}
                >
                  Enviar
                </Button>{" "}
                <Button variant="danger" onClick={this.handleCloseModal}>
                  Despejar
                </Button>
              </form>
            </Card.Body>
          </Card>
        </Modal>
      </div>
    );
  }
}
export default withRouter(NewReport);
