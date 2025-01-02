import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Championships from "../components/Championships/Championships";
import Championship from "../components/Championships/Championship";
import NewChampionship from "../components/Championships/NewChampionship";

export default (
    <Router>
        <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/championships" element={<Championships />} />
            <Route path="/championship/:id" element={<Championship />} />
            <Route path="/championship" element={<NewChampionship />} />
        </Routes>
    </Router>
);