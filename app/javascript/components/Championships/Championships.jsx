import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";

const Championships = () => {
    const navigate = useNavigate();
    const [championships, setChampionships] = useState([]);

    useEffect(() => {
        const url = "/championships";
        fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then((res) => {
                if (res.ok) {
                    return res.json();
                }
                throw new Error("Network response was not ok.");
            })
            .then((res) => setChampionships(res))
            .catch(() => navigate("/"));
    }, []);

    const allChampionships = championships.map((champ, index) => (
        <div key={index} className="col-md-6 col-lg-4">
            <div className="card mb-4">
                {/*<img*/}
                {/*    src={champ.logo}*/}
                {/*    className="card-img-top"*/}
                {/*    alt={`${champ.name} logo`}*/}
                {/*/>*/}
                <div className="card-body">
                    <h5 className="card-title">{champ.name}</h5>
                    <Link to={`/championship/${champ.id}`} className="btn custom-button">
                        View Championship
                    </Link>
                </div>
            </div>
        </div>
    ));

    const noChampionship = (
        <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
            <h4>
                No championships yet. Why not <Link to="/championship">create one</Link>
            </h4>
        </div>
    );

    return (
        <>
            <section className="jumbotron jumbotron-fluid text-center">
                <div className="container py-5">
                    <h1 className="display-4">Gerenciador de Peladas</h1>
                    <p className="lead text-muted">
                        Explore our collection of Sunday league football championships.
                    </p>
                </div>
            </section>
            <div className="py-5">
                <main className="container">
                    <div className="text-end mb-3">
                        <Link to="/championship" className="btn custom-button">
                            Create New Championship
                        </Link>
                    </div>
                    <div className="row">
                        {championships.length > 0 ? allChampionships : noChampionship}
                    </div>
                </main>
            </div>
        </>
    );
};

export default Championships;