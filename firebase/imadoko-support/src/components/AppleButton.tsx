import React from 'react';
import { css, cx } from '@emotion/css';
import { IOSAppBadge } from '../images';

const HEIGHT = 56;

type Props = {
    className?: string;
};

const styles = {
    container: css`
        display: block;
        height: ${HEIGHT}px;
    `
}


const AppleButton = (props: Props) => {
    const { className } = props;
    const style = cx(styles.container, className);

    return (
        <IOSAppBadge className={style} />
    )
};

export default AppleButton;
