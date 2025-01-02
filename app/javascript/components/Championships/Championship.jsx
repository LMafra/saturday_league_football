import React, { useState, useEffect } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";

const Championship = () => {
    const params = useParams();
    const navigate = useNavigate();
    const [championship, setChampionship] = useState({});

    useEffect(() => {
        const url = `/championships/${params.id}`;
        fetch(url)
            .then((response) => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("Network response was not ok.");
            })
            .then((response) => setChampionship(response))
            .catch(() => navigate("/championships"));
    }, [params.id]);

    const championshipDetails = Object.entries(championship).map(([key, value]) => (
        <li key={key}>{`${key}: ${value}`}</li>
    ));

    return (
        <div className="container py-5">
            <h1 className="display-4 mb-3">{championship.name || "Loading..."}</h1>
            <ul className="list-group">
                {championshipDetails}
            </ul>
            <Link to="/championships" className="btn btn-link mt-3">
                Back to championships
            </Link>
        </div>
    );
};

export default Championship;