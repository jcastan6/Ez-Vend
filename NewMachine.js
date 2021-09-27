import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Tab,
  Tabs,
} from "react-bootstrap";
import ImageUploader from "react-images-upload";

class NewMachine extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machineNo: "",
      machineType: "",
      clientName: "",
      serialNo: "",
      model: "",
      types: [],
      attributes: [],
      clients: [],
      file: [],
    };
    this.getTypes = this.getTypes.bind(this);
    //this.getAttributes = this.getAttributes.bind(this);
    this.getClients = this.getClients.bind(this);
    this.onDrop = this.onDrop.bind(this);
    this.getClients();
    this.getTypes();
    //this.getAttributes();
  }

  handleChange = (event) => {
    this.setState({
      [event.target.id]: event.target.value,
    });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    fetch("http://www.mantenimientoscvm.com/machines/newMachine", {
      method: "POST",
      credentials: "same-origin",
      body: JSON.stringify(this.state),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        this.props.getMachines();
      });
  };

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    if (this.state.machineNo === "") {
      return false;
    }
    if (this.state.machineType === "") {
      return false;
    }
    return true;
  }

  validateFileForm() {
    if (this.state.file.length === 0) {
      return false;
    }
    return true;
  }

  onDrop(file) {
    this.setState({
      file: this.state.file.concat(file),
    });
  }
  getTypes() {
    fetch(`http://www.mantenimientoscvm.com/machines/getTypes/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        let types = [];

        res.forEach((element) => {
          types.push(<option>{element.type}</option>);
        });

        this.setState({
          types: types,
          machineType: types[0].props.children,
        }),
          () => console.log();
      });
  }

  getClients() {
    fetch(`http://www.mantenimientoscvm.com/clients/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        let types = [];
        types.push(<option>{""}</option>);
        res.forEach((element) => {
          types.push(<option>{element.name}</option>);
        });

        this.setState({
          clients: types,
          clientName: types[0].props.children,
        }),
          () => console.log();
      });
  }

  handleFileSubmit = (event) => {
    event.preventDefault();
    const formData = new FormData();
    formData.append("file", this.state.file[0]);
    fetch("http://www.mantenimientoscvm.com/machines/batchAddMachines", {
      method: "POST",

      body: formData,
    }).then((res) => {
      this.props.getMachines();
    });
  };

  render() {
    return (
      <Tabs
        defaultActiveKey="home"
        id="uncontrolled-tab-example"
        className="mb-3"
      >
        <Tab eventKey="home" title="Single">
          <div>
            <br></br>
            <h1 id="justice">
              <b>Add New Machine</b>
            </h1>
            <br />
            <form onSubmit={this.handleSubmit}>
              <FormGroup className="userId" controlId="machineNo">
                <FormLabel>Machine Number</FormLabel>
                <FormControl
                  size="lg"
                  value={this.state.machineNo}
                  onChange={this.handleChange}
                ></FormControl>
              </FormGroup>
              <FormGroup className="userId" controlId="machineType">
                <FormLabel>Machine Type</FormLabel>
                <FormControl
                  as="select"
                  size="lg"
                  value={this.state.machineType}
                  onChange={this.handleChange}
                >
                  {this.state.types}
                </FormControl>
              </FormGroup>
              <FormGroup className="clientId" controlId="clientName">
                <FormLabel>Client</FormLabel>
                <FormControl
                  as="select"
                  size="lg"
                  value={this.state.clientName}
                  onChange={this.handleChange}
                >
                  {this.state.clients}
                </FormControl>
              </FormGroup>
              <FormGroup className="clientId" controlId="model">
                <FormLabel>Model</FormLabel>
                <FormControl
                  size="lg"
                  value={this.state.model}
                  onChange={this.handleChange}
                ></FormControl>
              </FormGroup>
              <FormGroup className="clientId" controlId="serialNo">
                <FormLabel>Serial No.</FormLabel>
                <FormControl
                  size="lg"
                  value={this.state.serialNo}
                  onChange={this.handleChange}
                ></FormControl>
              </FormGroup>

              {this.state.attributes}

              <Button
                block
                disabled={!this.validateForm()}
                type="submit"
                onClick={this.onSubmit}
              >
                Agregar
              </Button>
            </form>
          </div>
        </Tab>
        <Tab eventKey="profile" title="Batch">
          <div>
            <br></br>
            <h1 id="justice">
              <b>Add Machines</b>
            </h1>
            <br />
            <form onSubmit={this.handleFileSubmit}>
              <ImageUploader
                withIcon={true}
                buttonText="Choose File"
                accept="file"
                onChange={this.onDrop}
                withLabel={false}
                imgExtension={[".csv", ".json", ".xlsh"]}
                maxFileSize={5242880}
                singleImage
              />
              <Button
                block
                disabled={!this.validateFileForm()}
                type="submit"
                onClick={this.onSubmit}
              >
                Agregar
              </Button>
            </form>
          </div>
        </Tab>
      </Tabs>
    );
  }
}
export default withRouter(NewMachine);
