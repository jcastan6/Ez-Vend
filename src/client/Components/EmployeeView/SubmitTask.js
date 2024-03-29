import React, { Component } from "react";

import Sidebar from "react-sidebar";
import "react-data-table-component-extensions/dist/index.css";
import DataTableExtensions from "react-data-table-component-extensions";
import ImageUploader from "react-images-upload";
import DataTable, { createTheme } from "react-data-table-component";
import {
  Button,
  Row,
  Col,
  Container,
  FormGroup,
  FormLabel,
  FormControl,
  Spinner,
  Jumbotron,
  Card,
} from "react-bootstrap";
import "./employeeView.css";

export default class SubmitTask extends Component {
  constructor(props) {
    super(props);
    this.state = {
      task: this.props.task,
      machineNo: this.props.task.vendingMachine.machineNo,
      notes: "",
      pictures: [],
      employeeId: this.props.employee,
    };

    // this.getRoute = this.getRoute.bind(this);
    // this.renderTasks = this.renderTasks.bind(this);
    // this.setSidebarClose = this.setSidebarClose.bind(this);
    // this.setSidebarOpen = this.setSidebarOpen.bind(this);
    // this.getRoute();
    this.onDrop = this.onDrop.bind(this);
  }

  onDrop(picture) {
    this.setState({
      pictures: this.state.pictures.concat(picture),
    });
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();

    const formData = new FormData();
    formData.append("file", this.state.pictures[0]);
    formData.append("task", this.state.task.id);
    formData.append("machine", this.state.task.vendingMachine.id);
    formData.append("notes", this.state.notes);
    formData.append("employeeId", this.state.employeeId);
    this.setState({
      loading: true,
    }),
      () => console.log();
    fetch("https://www.mantenimientoscvm.com/machines/addMaintenanceHistory", {
      method: "POST",

      body: formData,
    }).then(() => this.handleRouteChange());
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    if (this.state.pictures.length === 0) {
      return false;
    }

    if (this.state.notes.length < 1) {
      return false;
    }

    return true;
  }

  render() {
    if (this.state.loading) {
      return (
        <Container>
          <br />
          <Jumbotron>
            <Spinner animation="border" role="status" />
          </Jumbotron>
        </Container>
      );
    }
    return (
      <div className="body">
        <Container fluid>
          <FormGroup className="userId" controlId="machineNo">
            <FormLabel>Numero de Maquina</FormLabel>
            <FormControl
              size="lg"
              value={this.state.task.vendingMachine.machineNo}
              onChange={this.handleChange}
              readOnly
            />
          </FormGroup>
          <FormGroup className="clientId" controlId="clientName">
            <FormLabel>Cliente</FormLabel>
            <FormControl
              as="Input"
              size="lg"
              readOnly
              value={this.state.task.vendingMachine.client.name}
              onChange={this.handleChange}
            >
              {this.state.clients}
            </FormControl>
          </FormGroup>
          <Card>
            <img src={this.state.task.image} width="100%" />
          </Card>
          <FormGroup className="clientId" controlId="notes">
            <FormLabel>Notas</FormLabel>
            <FormControl
              as="Input"
              size="lg"
              value={this.state.notes}
              onChange={this.handleChange}
            >
              {this.state.types}
            </FormControl>
          </FormGroup>
          <ImageUploader
            withIcon
            buttonText="Escoger Imagen"
            onChange={this.onDrop}
            withPreview
            withLabel={false}
            singleImage
            imgExtension={[".jpg", ".gif", ".png", ".gif"]}
            maxFileSize={52428800}
          />

          <Button
            size="lg"
            disabled={!this.validateForm()}
            type="submit"
            onClick={this.handleSubmit}
          >
            Enviar
          </Button>
        </Container>
      </div>
    );
  }
}
