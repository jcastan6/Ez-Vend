import React, { Component } from "react";
import { Typeahead } from "react-bootstrap-typeahead";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Container,
  Image,
  Carousel,
  Jumbotron,
  Spinner,
} from "react-bootstrap";
import ImageUploader from "react-images-upload";
import { retrieveCookie, deleteCookie, saveCookie } from "./ReportCookie";

class ReportMaintenance extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    let secret = false;
    if (retrieveCookie().secret) {
      secret = retrieveCookie().secret;
    } else {
      secret = retrieveCookie();
    }
    this.state = {
      machine: null,
      issue: "",
      machines: [],
      pictures: [],
      loading: false,
      pass: "",
      secret,
    };

    this.checkPass = this.checkPass.bind(this);
    this.getMachines = this.getMachines.bind(this);
    this.getMachines();
    this.onDrop = this.onDrop.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
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
    let machine = String(this.state.machine).split(" -")[0];
    const formData = new FormData();
    formData.append("file", this.state.pictures[0]);
    formData.append("machine", machine);
    formData.append("issue", this.state.issue);
    this.setState({
      loading: true,
    }),
      () => console.log();
    fetch("https://www.mantenimientoscvm.com/machines/submitReport", {
      method: "POST",

      body: formData,
    }).then(() => this.handleRouteChange());
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  validateForm() {
    if (this.state.issue === "") {
      return false;
    }
    if (this.state.machines.indexOf(String(this.state.machine)) === -1) {
      return false;
    }

    return true;
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  getMachines() {
    fetch(`https://www.mantenimientoscvm.com/machines/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        const machines = [];
        for (const machine of res) {
          if (machine.client) {
            const name = machine.machineNo + " - " + machine.client.name;
            machines.push(name);
          }
        }
        this.setState({
          machines: machines,
        }),
          () => console.log();
      });
  }

  render() {
    if (this.state.secret === false) {
      return (
        <div className="body-mobile">
          <form onSubmit={this.checkPass}>
            <img
              src="https://storage.googleapis.com/ezvend/cvm.png"
              width="100%"
              className="d-inline-block align-top"
              alt="CVM"
            />{" "}
            <FormGroup className="userId" controlId="pass">
              <FormLabel>Contraseña</FormLabel>
              <FormControl
                type="password"
                size="lg"
                value={this.state.pass}
                onChange={this.handleChange}
              ></FormControl>
            </FormGroup>
            <Button block type="submit" onClick={this.onSubmit}>
              Iniciar Sesión
            </Button>
          </form>
        </div>
      );
    }
    if (this.state.loading) {
      return (
        <Container>
          <br></br>
          <Jumbotron>
            <Spinner animation="border" role="status"></Spinner>
          </Jumbotron>
        </Container>
      );
    }

    return (
      <div>
        <Container>
          <br></br>
          <Jumbotron>
            <h1 id="justice">
              <b>Agregar Reporte</b>
            </h1>
            <br />

            <form onSubmit={this.handleSubmit}>
              <FormGroup className="userId" controlId="machine">
                <FormLabel>Máquina</FormLabel>
                <Typeahead
                  id="basic-typeahead-multiple"
                  labelKey="name"
                  clearButton
                  onChange={(option, e) => {
                    this.setState({
                      machine: option,
                    });
                  }}
                  options={this.state.machines}
                  placeholder="Elejir numero de maquina..."
                  selected={this.state.machine}
                />
              </FormGroup>
              <FormGroup className="clientId" controlId="issue">
                <FormLabel>Reporte</FormLabel>
                <FormControl
                  size="lg"
                  value={this.state.issue}
                  onChange={this.handleChange}
                ></FormControl>
              </FormGroup>
              <FormLabel>Fotografía</FormLabel>
              <ImageUploader
                withIcon={true}
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
              <Button variant="danger" onClick={this.delete}>
                Despejar
              </Button>
            </form>
          </Jumbotron>
        </Container>
      </div>
    );
  }
}
export default withRouter(ReportMaintenance);
