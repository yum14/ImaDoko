import React from 'react';
import { ClassNamesArg, css, cx } from '@emotion/css';
import { Link } from 'react-router-dom';
import { COLORS } from '../common/theme';

type Props = {
    className?: string;
    text: string;
    path: string;
}

const styles = {
    button: css`
        display: flex;
        justify-content: center;
        align-items: center;
        text-decoration: none;
        letter-spacing: 0.1em;
        color: #fff;
        background-color: ${COLORS.ACCENT};
        cursor: pointer;
        border-radius: 0.5rem;

        height: 48px;
        font-weight: bold;
        font-size: 1.4rem;
        width: 240px;
    `,
}

const LinkButton = (props: Props) => {
    const { className, text, path } = props;
    const style = cx(styles.button, className)

    return (
        <Link className={style} to={path}>{text}</Link>
    )
};

export default LinkButton;
