import React, { Component } from "react";

import Modal from "react-modal";

import { Row, Col, Button, Card, Container } from "react-bootstrap";

import DataTable, { createTheme } from "react-data-table-component";

import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";

import { BsArrowLeft, BsThreeDotsVertical } from "react-icons/bs";

import NewType from "./NewType";
import TypeEditor from "./TypeEditor";
export default class MachineTypes extends Component {
  constructor(props) {
    super(props);
    this.state = {
      types: [],
      showModal: false,
    };

    this.getTypes = this.getTypes.bind(this);
    this.getTypes();

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }
  getTypes() {
    fetch(`http://www.mantenimientoscvm.com/machines/getTypes`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState(
          {
            types: res,
          },
          () => console.log()
        );
      });
  }

  renderTypes() {
    const customStyles = {
      context: {
        background: "#cb4b16",
        text: "#FFFFFF",
      },
      headCells: {
        style: {
          fontSize: "14px",
        },
      },
      rows: {
        highlightOnHoverStyle: {
          backgroundColor: "rgb(230, 244, 244)",
          borderBottomColor: "#FFFFFF",
          outline: "1px solid #FFFFFF",
        },
      },
      pagination: {
        style: {
          border: "none",
        },
      },
    };
    const columns = [
      {
        name: "Type",
        selector: "type",
        sortable: true,
        style: {
          color: "#202124",
          fontSize: "14px",
          fontWeight: 500,
        },
      },
      {
        name: "Machine Count",
        selector: "count",
        sortable: true,
      },
      {
        selector: "edit",
        cell: (row) => {
          return <TypeEditor type={row} getTypes={this.getTypes} />;
        },
        right: true,
        button: true,
      },
    ];

    return (
      <DataTableExtensions
        filterHidden={false}
        columns={columns}
        data={this.state.types}
      >
        <DataTable
          title="Machines"
          data={this.state.types}
          customStyles={customStyles}
          columns={columns}
          pagination
          noheader
          pointerOnHover
          highlightOnHover
        />
      </DataTableExtensions>
    );
  }

  render() {
    return (
      <div>
        <div className="">
          <Container fluid>
            <Row>
              <Col lg={2}>
                <Button onClick={() => this.handleOpenModal("new")}>
                  Add Type
                </Button>
              </Col>
              <br></br>
              <br></br>
              <Col>
                <Row className="table">{this.renderTypes()}</Row>
              </Col>
            </Row>
          </Container>

          <Modal
            shouldCloseOnOverlayClick={true}
            onRequestClose={this.handleCloseModal}
            isOpen={this.state.showModal === "new"}
            className="modal-form"
          >
            <Card>
              <Card.Body>
                <NewType getTypes={this.getTypes}></NewType>
              </Card.Body>
            </Card>
          </Modal>
        </div>
      </div>
    );
  }
}
