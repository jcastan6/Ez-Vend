import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Card,
  Carousel,
  Container,
  Row,
  Col,
} from "react-bootstrap";
import Modal from "react-modal";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";
import HistoryEditor from "./HistoryEditor";
import { BsCamera, BsThreeDotsVertical } from "react-icons/bs";
class MaintenanceHistory extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machine: this.props.machine,
      maintenances: [],
    };
    this.getMaintenances = this.getMaintenances.bind(this);
    this.getMaintenances();
    this.renderModals = this.renderModals.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleRouteChange() {
    window.location.reload(false);
  }
  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  getMaintenances() {
    fetch(`http://192.168.1.153:4000/machines/getMaintenanceHistory/`, {
      body: JSON.stringify(this.state),
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState({
          maintenances: res,
        }),
          () => console.log();
      });
  }

  renderModals() {
    const modals = [];
    for (const element of this.state.maintenances) {
      modals.push(
        <Modal
          shouldCloseOnOverlayClick={true}
          onRequestClose={this.handleCloseModal}
          className="modal-info"
          isOpen={this.state.showModal === element.id}
        >
          <Container>
            <Row>
              <Col>
                <HistoryEditor
                  getMaintenances={this.getMaintenances}
                  report={element}
                ></HistoryEditor>
              </Col>
              <Col>
                <Card>
                  <Card.Body>
                    <img src={element.image} width="100%"></img>
                  </Card.Body>
                </Card>
              </Col>
            </Row>
          </Container>
        </Modal>
      );
    }
    return modals;
  }
  renderTasks() {
    const columns = [
      {
        name: "Task",
        selector: "task",
        sortable: true,
      },
      {
        name: "Completed",
        selector: "createdAt",
        sortable: true,
      },
      {
        name: "Completed by",
        selector: "employee",
        sortable: true,
      },
      {
        cell: (row) => {
          return (
            <BsThreeDotsVertical
              onClick={() => this.handleOpenModal(row.id)}
            ></BsThreeDotsVertical>
          );
        },
      },
    ];

    return (
      <div>
        {this.renderModals()}
        <Card body className="table">
          <Card.Title>Maintenance Reports</Card.Title>

          <DataTable
            data={this.state.maintenances}
            noHeader
            theme="machines"
            columns={columns}
            pagination
            highlightOnHover
            pointerOnHover
            onRowDoubleClicked={(row) => {
              this.handleOpenModal(row.id);
            }}
          />
        </Card>
      </div>
    );
  }

  render() {
    return <div>{this.renderTasks()}</div>;
  }
}
export default withRouter(MaintenanceHistory);
