import React, { Component } from "react";
import { PullToRefresh } from "react-js-pull-to-refresh";
import Sidebar from "react-sidebar";
import "react-data-table-component-extensions/dist/index.css";
import DataTableExtensions from "react-data-table-component-extensions";
import DataTable, { createTheme } from "react-data-table-component";
import {
  PullDownContent,
  ReleaseContent,
  RefreshContent,
} from "react-js-pull-to-refresh";
import "./employeeView.css";

import {
  Button,
  Row,
  Col,
  Container,
  Jumbotron,
  Form,
  Card,
} from "react-bootstrap";
import "./employeeView.css";
import SubmitTask from "./SubmitTask";

export default class EmployeeView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      employeeId: 1,
      routeTasks: [],
      sidebarOpen: false,
      refreshingContent: false,
    };
    this.getRoute = this.getRoute.bind(this);
    this.renderTasks = this.renderTasks.bind(this);
    this.setSidebarClose = this.setSidebarClose.bind(this);
    this.setSidebarOpen = this.setSidebarOpen.bind(this);
    this.onRefresh = this.onRefresh.bind(this);
    this.getRoute();
  }

  getRoute() {
    fetch(
      `http://192.168.1.153:4000/users/getEmployeeRoute/${this.state.employeeId}`,
      {
        method: "GET",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((res) => {
        let tasks = res.maintenanceTasks;
        tasks.sort((a, b) =>
          a.employeeTasks.priority > b.employeeTasks.priority ? 1 : -1
        );

        this.setState(
          {
            routes: res,
            refreshingContent: false,
            routeTasks: tasks,
          },
          () => console.log()
        );
      });
  }
  setSidebarOpen(open) {
    window.scrollTo(0, 0);
    let task = this.state.routeTasks.at(open);
    let content = (
      <div className="body">
        <br></br>
        <Container fluid>
          <SubmitTask task={task} employee={this.state.employeeId}></SubmitTask>
        </Container>
      </div>
    );
    this.setState({ sidebarOpen: open, sidebar: content });
  }

  setSidebarClose() {
    this.setState({ sidebarOpen: false, sidebar: null });
  }

  renderTasks() {
    if (this.state.routeTasks.length > 0) {
      let cards = [];

      for (let index = 0; index < this.state.routeTasks.length; index++) {
        cards.push(
          <div>
            <br />

            <a onClick={() => this.setSidebarOpen(index)}>
              <Card
                body
                className={
                  this.state.routeTasks[index].emergency === true
                    ? "emergency-task table task-card"
                    : "table task-card "
                }
              >
                <Row>
                  <Col className="index-col" xs={3}>
                    <h1>{index + 1}</h1>
                  </Col>
                  <Col>
                    <Card.Title>
                      <p>
                        Maquina:{" "}
                        {this.state.routeTasks[index].vendingMachine.machineNo}
                      </p>
                      <p>
                        Cliente:{" "}
                        {
                          this.state.routeTasks[index].vendingMachine.client
                            .name
                        }
                      </p>
                      <p>Mantenimiento: {this.state.routeTasks[index].task}</p>
                    </Card.Title>
                  </Col>
                </Row>
              </Card>
            </a>
          </div>
        );
      }

      return cards;
    }
  }
  onRefresh() {
    return new Promise((resolve) => {
      setTimeout(resolve, 500);
      this.getRoute();
    });
  }

  render() {
    return (
      <PullToRefresh
        onRefresh={this.onRefresh}
        pullDownThreshold={200}
        triggerHeight={150}
        refreshContent={<RefreshContent />}
        pullDownContent={<PullDownContent />}
      >
        <div className="body-mobile">
          <Container className="body-mobile">
            <Sidebar
              touch
              pullRight
              sidebar={this.state.sidebar}
              open={this.state.sidebarOpen !== false}
              onSetOpen={() => this.setSidebarClose()}
              styles={{
                sidebar: {
                  background: "white",
                  width: "100%",
                },
              }}
            />{" "}
            <br></br>
            <Card body className="table task-card">
              <Card.Title>Open Tasks</Card.Title>
            </Card>
            {this.renderTasks()}
          </Container>
        </div>
      </PullToRefresh>
    );
  }
}
